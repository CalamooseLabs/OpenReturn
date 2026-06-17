-- Built-in permissions, roles, and grants. Guarded on the `role` table (runs
-- only on a fresh DB); every statement is INSERT OR IGNORE so it is idempotent.
-- The route -> permission mapping lives in code (the routers); these rows decide
-- which roles hold which permissions, and are editable at runtime via the CLI.

INSERT OR IGNORE INTO permission (code, description) VALUES
  ('org:read',     'Read organizations'),
  ('org:write',    'Create and edit organizations'),
  ('person:read',  'Read people and memberships'),
  ('person:write', 'Create and edit people and memberships'),
  ('tag:read',     'Read tags'),
  ('tag:write',    'Apply and remove tags'),
  ('list:read',    'Read organization lists'),
  ('list:write',   'Create and edit organization lists'),
  ('filing:read',  'Read 990 filings and reported data'),
  ('filing:write', 'Create filings and store reported data'),
  ('score:read',   'Read scores'),
  ('score:write',  'Compute and grade scores'),
  ('upload:write', 'Upload 990 filing archives'),
  ('follow:read',  'Read the caller''s organization watchlist'),
  ('follow:write', 'Follow and unfollow organizations'),
  ('user:admin',   'Administer users and roles');

INSERT OR IGNORE INTO role (code, name, description, is_builtin) VALUES
  ('admin',   'Administrator', 'Full access, including user administration', 1),
  ('editor',  'Editor',        'Read and edit organizations, people, tags, lists, and scores', 1),
  ('viewer',  'Viewer',        'Read-only access to all data', 1),
  ('service', 'Service',       'Restricted read-only access for programs (API keys)', 1);

-- admin: every permission.
INSERT OR IGNORE INTO role_permission (role_id, permission_id)
  SELECT (SELECT role_id FROM role WHERE code = 'admin'), permission_id FROM permission;

-- editor: everything except user administration.
INSERT OR IGNORE INTO role_permission (role_id, permission_id)
  SELECT (SELECT role_id FROM role WHERE code = 'editor'), permission_id FROM permission
  WHERE code IN ('org:read','org:write','person:read','person:write','tag:read','tag:write',
                 'list:read','list:write','filing:read','filing:write','score:read','score:write',
                 'upload:write','follow:read','follow:write');

-- viewer: all reads.
INSERT OR IGNORE INTO role_permission (role_id, permission_id)
  SELECT (SELECT role_id FROM role WHERE code = 'viewer'), permission_id FROM permission
  WHERE code IN ('org:read','person:read','tag:read','list:read','filing:read','score:read',
                 'follow:read','follow:write');

-- service (API-key programs): restricted reads only.
INSERT OR IGNORE INTO role_permission (role_id, permission_id)
  SELECT (SELECT role_id FROM role WHERE code = 'service'), permission_id FROM permission
  WHERE code IN ('org:read','person:read','tag:read','list:read','filing:read','score:read',
                 'follow:read');
