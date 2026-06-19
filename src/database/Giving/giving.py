from database.base import Database


class GivingDatabase(Database):
  """Shared record of gifts the team gave to an org (reached as ``db.giving``).

  Hand-entered "giving data" — the relationship "we gave them $X in year Y" —
  distinct from the ``grant_edge`` graph parsed out of 990 filings. Team-wide
  (not per-user); each gift records who entered it and when. A ``Database``
  subclass sharing the coordinator's connection; EINs are normalized + validated
  via ``db.orgs`` and every change is audited.
  """

  def __init__(self, db) -> None:
    self._db = db
    super().__init__("Giving", "Giving", connection=db.connection, cursor=db.cursor)

  @staticmethod
  def _summary(gifts: list[dict]) -> dict:
    """Roll a list of gifts into totals: count, summed amount, and amount by year
    (newest first). Mirrors AppearanceDatabase._grant_summary."""
    by_year: dict[int, float] = {}
    total = 0.0
    for g in gifts:
      amt = g.get("amount") or 0.0
      total += amt
      yr = g.get("fiscal_year")
      if yr is not None:
        by_year[yr] = by_year.get(yr, 0.0) + amt
    return {"gift_count": len(gifts), "total_amount": total,
            "by_year": [{"year": y, "amount": by_year[y]} for y in sorted(by_year, reverse=True)]}

  def _row(self, r) -> dict:
    return {"gift_id": r[0], "amount": r[1], "fiscal_year": r[2], "gift_date": r[3],
            "purpose": r[4], "created_by_user_id": r[5], "created_by_label": r[6],
            "created_at": r[7]}

  _COLS = ("gift_id, amount, fiscal_year, gift_date, purpose, "
           "created_by_user_id, created_by_label, created_at")

  def list_giving(self, org_ein: str) -> dict:
    """An org's recorded gifts (newest year first) + a by-year summary."""
    ein = self._db.orgs.try_normalize_ein(org_ein)
    rows = self.cursor.execute(
      f"SELECT {self._COLS} FROM giving WHERE org_ein = ? "
      "ORDER BY fiscal_year DESC, gift_date DESC, gift_id DESC", (ein,)).fetchall()
    gifts = [self._row(r) for r in rows]
    return {"ein": ein, "gifts": gifts, "summary": self._summary(gifts)}

  def add_gift(self, org_ein: str, amount, *, fiscal_year=None, gift_date: str | None = None,
               purpose: str | None = None, actor=None) -> dict:
    """Record a gift to an org. Raises ValueError on a bad amount or unknown org.
    ``amount`` is coerced to a float; ``fiscal_year`` to an int when present."""
    if isinstance(amount, bool):  # bool is an int subclass; float(True)==1.0
      raise ValueError("amount must be a number")
    try:
      amount = float(amount)
    except (ValueError, TypeError):
      raise ValueError("amount must be a number")
    year = None
    if fiscal_year is not None and str(fiscal_year).strip() != "":
      try:
        year = int(fiscal_year)
      except (ValueError, TypeError):
        raise ValueError("fiscal_year must be an integer")
    ein = self._db.orgs.try_normalize_ein(org_ein)
    if not self.cursor.execute("SELECT 1 FROM organization WHERE ein = ?", (ein,)).fetchone():
      raise ValueError(f"organization {ein} not found")
    user_id = actor.user_id if (actor is not None and getattr(actor, 'kind', None) == 'user') else None
    label = actor.label if actor is not None else None
    self.cursor.execute(
      "INSERT INTO giving (org_ein, amount, fiscal_year, gift_date, purpose, "
      "created_by_user_id, created_by_label) VALUES (?, ?, ?, ?, ?, ?, ?)",
      (ein, amount, year, (gift_date or None), (purpose or None), user_id, label))
    gift_id = self.cursor.lastrowid
    self._db.audit.record(actor, 'create', 'giving', gift_id,
                          {'org_ein': ein, 'amount': amount, 'fiscal_year': year}, commit=False)
    self.connection.commit()
    row = self.cursor.execute(
      f"SELECT {self._COLS} FROM giving WHERE gift_id = ?", (gift_id,)).fetchone()
    return self._row(row)

  def delete_gift(self, gift_id: int, *, actor=None) -> bool:
    """Remove a recorded gift by id. Returns True if a row was deleted."""
    self.cursor.execute("DELETE FROM giving WHERE gift_id = ?", (gift_id,))
    removed = self.cursor.rowcount > 0
    if removed:
      self._db.audit.record(actor, 'delete', 'giving', gift_id, None, commit=False)
    self.connection.commit()
    return removed
