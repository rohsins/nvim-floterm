local manager = require("floterm.manager")

local M = {}

function M.setup(opts)
    opts = opts or {}

    -- Default highlights
    vim.api.nvim_set_hl(0, "FlotermActive",   { fg = "#ffffff", bg = "#5f87af", bold = true })
    vim.api.nvim_set_hl(0, "FlotermInactive", { fg = "#aaaaaa", bg = "NONE" })

    -- Keymaps
    vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
    vim.keymap.set({ "n", "t" }, "<leader>tt", function() manager.toggle_terminal() end, { desc = "Hide/Unhide terminal" })
    vim.keymap.set({ "n", "t" }, "<leader>tn", function() manager.new_terminal() end, { desc = "New terminal" })
    vim.keymap.set({ "n", "t" }, "<leader>ts", function() manager.select_terminal() end, { desc = "Select terminal" })
    vim.keymap.set({ "n", "t" }, "<leader>th", function() manager.prev_terminal() end, { desc = "Prev terminal" })
    vim.keymap.set({ "n", "t" }, "<leader>tl", function() manager.next_terminal() end, { desc = "Next terminal" })

    -- Commands
    vim.api.nvim_create_user_command("FlotermNew", function() manager.new_terminal() end, {})
    vim.api.nvim_create_user_command("FlotermToggle", function(l_opts)
	local id = tonumber(l_opts.args)
	manager.toggle_terminal(id)
    end, { nargs = "?" })
    vim.api.nvim_create_user_command("FlotermSelect", function() manager.select_terminal() end, {})
    vim.api.nvim_create_user_command("FlotermNext", function() manager.next_terminal() end, {})
    vim.api.nvim_create_user_command("FlotermPrev", function() manager.prev_terminal() end, {})
end

function M.statusline()
    return manager.statusline()
end

return M

