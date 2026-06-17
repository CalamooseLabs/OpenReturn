import json

from database.base import Database


class PermissionError_(Exception):
  """A viewer tried to read/edit a list they don't own (private)."""


class ListsDatabase(Database):
  """Organization lists (reached as ``db.lists``): per-user **private** or
  **public**, and **static** (explicit members) or **smart** (members computed
  from a tag query). Owner/visibility checks take a ``viewer_user_id`` (the
  logged-in user's id, or None for a program). Mutations are audited.
  """

  _VISIBILITIES = ('private', 'public')
  _KINDS = ('static', 'smart')

  @staticmethod
  def _validate_definition(definition) -> None:
    """A smart-list definition must be a dict with a non-empty list of string
    tags. Raises ValueError on a bad shape so the router returns a clean error
    (not a 500) and no garbage state is stored."""
    if not isinstance(definition, dict):
      raise ValueError("a smart list requires a definition object")
    tags = definition.get('tags')
    if not isinstance(tags, list) or not tags or not all(isinstance(t, str) for t in tags):
      raise ValueError("a smart list requires a definition with a non-empty list of tag names")

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Lists", "Lists", connection=db.connection, cursor=db.cursor)

  @staticmethod
  def _row(r) -> dict:
    return {"list_id": r[0], "name": r[1], "owner_user_id": r[2],
            "visibility": r[3], "kind": r[4],
            "definition": json.loads(r[5]) if r[5] else None,
            "created_by": r[6], "created_at": r[7], "updated_at": r[8]}

  _COLS = ("list_id, name, owner_user_id, visibility, kind, definition, "
           "created_by, created_at, updated_at")

  @staticmethod
  def _can_view(row: dict, viewer_user_id) -> bool:
    return row["visibility"] == "public" or (
      row["owner_user_id"] is not None and row["owner_user_id"] == viewer_user_id)

  @staticmethod
  def _can_edit(row: dict, viewer_user_id) -> bool:
    # Strict owner match: a user edits only their own lists, and a program-owned
    # (NULL owner) list is editable only by a program caller (viewer None) — NOT
    # by any list:write user, which would be a privilege escalation.
    return row["owner_user_id"] == viewer_user_id

  def _fetch(self, list_id: int) -> dict | None:
    row = self.cursor.execute(
      f"SELECT {self._COLS} FROM org_list WHERE list_id = ?", (list_id,)).fetchone()
    return self._row(row) if row else None

  def create_list(self, name: str, *, owner_user_id=None, visibility='private',
                  kind='static', definition=None, actor=None) -> dict:
    if not name or not str(name).strip():
      raise ValueError("name is required")
    if visibility not in self._VISIBILITIES:
      raise ValueError(f"visibility must be one of {self._VISIBILITIES}")
    if kind not in self._KINDS:
      raise ValueError(f"kind must be one of {self._KINDS}")
    if visibility == 'private' and owner_user_id is None:
      raise ValueError("a private list requires a logged-in owner")
    if kind == 'smart':
      self._validate_definition(definition)
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO org_list (name, owner_user_id, visibility, kind, definition, "
      "created_by) VALUES (?, ?, ?, ?, ?, ?)",
      (name, owner_user_id, visibility, kind,
       json.dumps(definition) if definition else None, label))
    list_id = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'list', list_id,
                          {'name': name, 'kind': kind, 'visibility': visibility}, commit=False)
    self.connection.commit()
    return self._fetch(list_id)

  def get_list(self, list_id: int, viewer_user_id=None) -> dict | None:
    row = self._fetch(list_id)
    if row is None or not self._can_view(row, viewer_user_id):
      return None
    return row

  def list_lists(self, viewer_user_id=None) -> list[dict]:
    """Lists visible to the viewer: all public lists plus the viewer's own."""
    rows = self.cursor.execute(
      f"SELECT {self._COLS} FROM org_list "
      "WHERE visibility = 'public' OR owner_user_id = ? ORDER BY name",
      (viewer_user_id,)).fetchall()
    return [self._row(r) for r in rows]

  def update_list(self, list_id: int, fields: dict, *, viewer_user_id=None, actor=None) -> dict | None:
    row = self._fetch(list_id)
    if row is None:
      return None
    if not self._can_edit(row, viewer_user_id):
      raise PermissionError_("not the owner of this list")
    if 'visibility' in fields and fields['visibility'] not in self._VISIBILITIES:
      raise ValueError(f"visibility must be one of {self._VISIBILITIES}")
    if 'visibility' in fields and fields['visibility'] == 'private' and row['owner_user_id'] is None:
      raise ValueError("a private list requires an owner")
    if 'definition' in fields and row['kind'] == 'smart':
      self._validate_definition(fields['definition'])
    sets, params = [], []
    for col in ('name', 'visibility'):
      if col in fields:
        sets.append(f"{col} = ?")
        params.append(fields[col])
    if 'definition' in fields:
      sets.append("definition = ?")
      params.append(json.dumps(fields['definition']) if fields['definition'] else None)
    sets.append("updated_at = datetime('now')")
    self.cursor.execute(
      f"UPDATE org_list SET {', '.join(sets)} WHERE list_id = ?", [*params, list_id])
    self._db.audit.record(actor, 'update', 'list', list_id,
                          {'fields': sorted(fields.keys())}, commit=False)
    self.connection.commit()
    return self._fetch(list_id)

  def delete_list(self, list_id: int, *, viewer_user_id=None, actor=None) -> bool:
    row = self._fetch(list_id)
    if row is None:
      return False
    if not self._can_edit(row, viewer_user_id):
      raise PermissionError_("not the owner of this list")
    self.cursor.execute("DELETE FROM org_list WHERE list_id = ?", (list_id,))
    self._db.audit.record(actor, 'delete', 'list', list_id, commit=False)
    self.connection.commit()
    return True

  def add_member(self, list_id: int, org_ein: str, *, viewer_user_id=None, actor=None) -> bool:
    row = self._fetch(list_id)
    if row is None:
      raise ValueError(f"list {list_id} not found")
    if not self._can_edit(row, viewer_user_id):
      raise PermissionError_("not the owner of this list")
    if row["kind"] != "static":
      raise ValueError("members can only be added to a static list (smart lists are tag-derived)")
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute(
        "SELECT 1 FROM organization WHERE ein = ?", (org_ein,)).fetchone():
      raise ValueError(f"organization {org_ein} not found")
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT OR IGNORE INTO org_list_member (list_id, org_ein, added_by) VALUES (?, ?, ?)",
      (list_id, org_ein, label))
    self._db.audit.record(actor, 'update', 'list', list_id, {'add_member': org_ein}, commit=False)
    self.connection.commit()
    return True

  def remove_member(self, list_id: int, org_ein: str, *, viewer_user_id=None, actor=None) -> bool:
    row = self._fetch(list_id)
    if row is None:
      raise ValueError(f"list {list_id} not found")
    if not self._can_edit(row, viewer_user_id):
      raise PermissionError_("not the owner of this list")
    org_ein = self._db.orgs.try_normalize_ein(org_ein)
    self.cursor.execute(
      "DELETE FROM org_list_member WHERE list_id = ? AND org_ein = ?", (list_id, org_ein))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'update', 'list', list_id, {'remove_member': org_ein}, commit=False)
    self.connection.commit()
    return removed

  def list_members(self, list_id: int, viewer_user_id=None) -> list[dict] | None:
    """The organizations on a list — explicit members for a static list, or
    tag-resolved for a smart list. None if the list is missing or not visible."""
    row = self.get_list(list_id, viewer_user_id)
    if row is None:
      return None
    if row["kind"] == "smart":
      defn = row["definition"] or {}
      eins = self._db.tags.orgs_with_tags(defn.get("tags", []), defn.get("match", "any"))
      if not eins:
        return []
      qmarks = ",".join("?" * len(eins))
      rows = self.cursor.execute(
        f"SELECT ein, name FROM organization WHERE ein IN ({qmarks}) ORDER BY name", eins).fetchall()
    else:
      rows = self.cursor.execute(
        "SELECT o.ein, o.name FROM org_list_member m JOIN organization o ON o.ein = m.org_ein "
        "WHERE m.list_id = ? ORDER BY o.name", (list_id,)).fetchall()
    return [{"ein": r[0], "name": r[1]} for r in rows]
