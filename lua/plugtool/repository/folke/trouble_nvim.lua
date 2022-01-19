return {
    needs = { 'kyazdani42/nvim-web-devicons' },
    after = { 'kyazdani42/nvim-web-devicons', 'folke/lsp-colors.nvim' },
    config = function()
        require('trouble').setup {}
    end,
}
