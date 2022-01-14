return {
    needs = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    after = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
        require('startup').setup()
    end,
}
