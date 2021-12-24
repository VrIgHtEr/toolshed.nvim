return {
    config = function()
        vim.api.nvim_exec("set termguicolors", true)
        vim.api.nvim_exec("colorscheme aurora", true)
    end
}
