return {
    needs = {
        'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap',
        'nvim-treesitter/nvim-treesitter'
    },
    after = {
        'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap',
        'nvim-treesitter/nvim-treesitter'
    },
    config = function() require'telescope'.load_extension("dap") end
}
