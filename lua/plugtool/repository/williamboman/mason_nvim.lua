return {
    needs = { 'neovim/nvim-lspconfig', 'williamboman/mason-lspconfig.nvim', 'mfussenegger/nvim-dap' },
    before = { 'neovim/nvim-lspconfig', 'williamboman/mason-lspconfig.nvim' },
    config = function()
        require('mason').setup()
    end,
}
