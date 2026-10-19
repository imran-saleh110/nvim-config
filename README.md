# Keybinds

## General Editor & Text

| Key | Mode | Action |
| --- | --- | --- |
| `n` | Normal | Next search result (centered) |
| `N` | Normal | Previous search result (centered) |
| `<C-d>` | Normal | Half page down (centered) |
| `<C-u>` | Normal | Half page up (centered) |
| `>` | Visual | Indent selection and reselect |
| `<` | Visual | Outdent selection and reselect |
| `J` | Normal | Join lines (keep cursor position) |
| `J` | Visual | Move selection down |
| `K` | Visual | Move selection up |
| `p` | Visual | Paste without yanking |
| `s` | Normal | Change line without yanking |
| `s` | Visual | Change selection without yanking |
| `dd` | Normal | Delete line (with highlight) |
| `<leader>s` | Normal | Substitute word under cursor |

## Window & Buffer Management

| Key | Mode | Action |
| --- | --- | --- |
| `<C-h>` | Normal | Move window to far left |
| `<C-l>` | Normal | Move window to far right |
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>v` | Normal | Vertical split |
| `<leader>w` | Normal | Move split focus |
| `<leader>c` | Normal | Close split |
| `<C-Down>` | Normal | Decrease split height |
| `<C-Left>` | Normal | Decrease split width |
| `<C-Right>` | Normal | Increase split width |

## File & Project Navigation

| Key | Mode | Action |
| --- | --- | --- |
| `<C-n>` | Normal | Toggle NvimTree file explorer |
| `<leader>e` | Normal | Toggle Snacks file explorer |
| `<leader>gd` | Normal | [Diffview] Open Diffview |
| `<leader>ff` | Normal | [Telescope] Find files |
| `<leader>fg` | Normal | [Telescope] Live grep |
| `<leader>fb` | Normal | [Telescope] Find buffers |
| `<leader>rc` | Normal | Edit config (init.lua) |
| `<leader>t` | Normal | Insert template for filetype |

## Telescope (Search)

| Key | Mode | Action |
| --- | --- | --- |
| `<leader><space>` | Normal | Search workspace symbols (LSP) |
| `<leader>sf` | Normal | Search Functions (LSP) |
| `<leader>sw` | Normal | Grep word under cursor |
| `<leader>sd` | Normal | Search diagnostics |
| `<leader>sh` | Normal | Search help tags |

## LSP & Code (Active in code buffers)

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | Normal | Go to Definition |
| `K` | Normal | Hover documentation |
| `<leader>la` | Normal | Code Actions |
| `<leader>ca` | Normal | Code Actions |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>lr` | Normal | Rename symbol |
| `<leader>ld` | Normal | Go to Definition |
| `<leader>lh` | Normal | Hover Docs |
| `<leader>li` | Normal | Go to Implementation |
| `<leader>lt` | Normal | Type Definition |
| `<leader>vr` | Normal | View References |
| `<leader>vws` | Normal | View Workspace Symbols |
| `<leader>vd` | Normal | Show diagnostic in float |
| `<leader>lf` | Normal | Format buffer (LSP) |
| `<C-h>` | Insert | Signature Help (in insert mode) |
