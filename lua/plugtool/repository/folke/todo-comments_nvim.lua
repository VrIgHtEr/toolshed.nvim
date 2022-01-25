return {
    needs = { 'nvim-lua/plenary.nvim' },
    after = { 'folke/trouble.nvim' },
    config = function()
        require('todo-comments').setup {}
    end,
}
