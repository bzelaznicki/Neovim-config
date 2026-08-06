My Neovim config, based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Navigation and IDE keys

The LazyVim-inspired layer lives in `lua/custom/plugins/lazyvim_ux.lua`.

| Key | Action |
| --- | --- |
| `<leader><space>` / `<leader>ff` | Find files from the project root |
| `<leader>,` / `<leader>fb` | Switch between open buffers |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>e` | Project file explorer |
| `<leader>/` | Search text across the project |
| `<leader>:` | Search command history |
| `<leader>bd` | Delete the current buffer |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Current-buffer diagnostics |
| `<leader>cs` | Document symbols and structure |
| `<leader>cl` | LSP definitions and references |
| `<leader>co` | Toggle the code outline |
| `[s` / `]s` | Previous / next code symbol |
| `<leader>mh` | Message and command-output history |

The project root is detected from Git, Composer, Node, Python, and .NET
solution markers.
