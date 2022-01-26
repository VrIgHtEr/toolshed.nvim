return {
    preload = function()
        vim.o.termguicolors = true
    end,
    config = function()
        vim.api.nvim_exec('colorscheme aurora', true)
    end,
}
