return {
    needs = {
        'nvim-telescope/telescope.nvim',
    },
    after = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require('telescope').load_extension 'file_browser'
    end,
}
