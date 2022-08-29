return {
    needs = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' },
    before = { 'neovim/nvim-lspconfig' },
    after = { 'williamboman/mason.nvim' },
    config = function()
        require('mason-lspconfig').setup()
    end,
}
