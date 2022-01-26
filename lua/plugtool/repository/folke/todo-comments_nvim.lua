return {
    needs = { 'nvim-lua/plenary.nvim' },
    after = { 'nvim-lua/plenary.nvim', 'folke/trouble.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
        require('todo-comments').setup {}
    end,
}
