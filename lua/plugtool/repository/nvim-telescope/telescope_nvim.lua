return {
    needs = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('telescope').setup {
            extensions = require('plugtool').state 'nvim-telescope/telescope.nvim',
        }
    end,
}
