return {
    needs = { 'williamboman/mason.nvim' },
    after = { 'williamboman/mason.nvim' },
    config = function()
        require('mason-tool-installer').setup {}
    end,
}
