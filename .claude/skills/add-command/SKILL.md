---
name: add-command
description: Add a new subcommand to sshmgr with argparse registration, cmd_* implementation, and Zsh completion update.
---

When invoked:

1. Define command: name, aliases, description, and arguments
2. Add subparser registration in main() following existing pattern:
   `p = sub.add_parser('<name>', aliases=[...], help='...')`
3. Implement cmd_<name>(args) function:
   - call _load_connections() at start
   - validate inputs and report errors with C color codes
   - perform operation
   - call _save_connections() if connections were modified (chmod 600)
   - print result using C.BOLD, C.GREEN, C.RED, C.RESET
4. Add entry to Zsh completion script (completions/_sshmgr) if command accepts connection names or tags
5. Update README.md command list section

Rules:
- function name: cmd_<primary_name>
- all aliases registered in add_parser aliases= list
- confirm before destructive operations unless -y/--yes flag is passed
- match output style of existing commands (colored, concise)

Output:
- main() parser registration block
- cmd_* function implementation
- Zsh completion addition
- README entry
