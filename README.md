# nvim-floterm

A lightweight floating terminal manager for Neovim ✨

## Features
- Floating terminals with rounded borders
- Multiple terminals with IDs
- Toggle, create, select, cycle next/prev
- Statusline/tabline integration with highlights
- Works with `vim.ui.select` (Telescope, Dressing, etc.)

## Installation

Using **lazy.nvim**:

```lua
{
    "rohsins/nvim-floterm",
    opts = {
    }
}
```

## Usage
### Commands
- :FlotermNew → create new terminal
- :FlotermToggle [id] → toggle terminal (last if no ID)
- :FlotermSelect → pick terminal from menu
- :FlotermNext → cycle to next terminal
- :FlotermPrev → cycle to prev terminal

## Default Keymaps
- <leader>tn → new terminal
- <leader>tt → Hide/Unhide terminal
- <leader>ts → select terminal
- <leader>th → previous terminal
- <leader>tl → next terminal
- <esc><esc> (in terminal mode) → exit to normal mode

