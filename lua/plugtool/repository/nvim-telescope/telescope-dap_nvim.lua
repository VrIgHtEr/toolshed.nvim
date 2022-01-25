return {
    plugin_type = require('plugtool.constants').type.gui,
    needs = {
        'nvim-telescope/telescope.nvim',
        'mfussenegger/nvim-dap',
        'nvim-treesitter/nvim-treesitter',
    },
    after = {
        'mfussenegger/nvim-dap',
    },
    config = function()
        require('telescope').load_extension 'dap'
    end,
}
