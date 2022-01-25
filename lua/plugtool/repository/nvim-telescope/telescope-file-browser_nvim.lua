return {
    plugin_type = require('plugtool.constants').type.gui,
    needs = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require('telescope').load_extension 'file_browser'
    end,
}
