---
name: add-connection
description: Add a new SSH connection to sshmgr — define fields, use the add command or import from ~/.ssh/config, and verify.
---

When invoked:

1. Gather connection details:
   - host (required), port (default 22), user, identity_file
   - description, alias (short name for tab-complete)
   - tags (comma-separated), favorite (true/false)
   - proxy_jump (name of an existing sshmgr connection to use as bastion)
   - ssh_options (extra -o flags if needed)

2. Add the connection:
   - Option A (direct): `sshmgr add <name> --host <host> --user <user> [--port N] [--key PATH] [--tag TAG]`
   - Option B (import): `sshmgr import` to pull from ~/.ssh/config

3. Verify:
   - `sshmgr show <name>` — inspect stored fields
   - `sshmgr list` — confirm it appears in listing

4. Test connectivity (optional): `sshmgr connect <name>`

Notes:
- proxy_jump must reference an existing sshmgr connection by name
- identity_file path must be absolute; use ~/.ssh/ prefix for home-relative keys
- connections.json is stored at ~/.config/sshmgr/ with chmod 600

Output:
- Connection definition summary
- sshmgr add command to reproduce it
- Verification output
