return {
    needs = {"mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim"},
    after = {"mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim"},
    config = function()
        require'telescope'.load_extension("cmake")
        require('cmake').setup({
            type = 'codelldb',
            request = 'launch',
            stopOnEntry = false,
            runInTerminal = false
        })
    end
}
