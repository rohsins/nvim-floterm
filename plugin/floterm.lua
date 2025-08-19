if vim.g.loaded_floterm then
    return
end
vim.g.loaded_floterm = true

require("floterm").setup()

