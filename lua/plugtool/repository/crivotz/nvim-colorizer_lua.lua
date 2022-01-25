return {
    plugin_type = require('plugtool.constants').type.gui,
    config = function()
        require('colorizer').setup()
    end,
    preload = function()
        vim.o.termguicolors = true
    end,
}
