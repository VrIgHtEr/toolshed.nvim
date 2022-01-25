return {
    plugin_type = require('plugtool.constants').type.gui,
    preload = function()
        vim.o.termguicolors = true
    end,
    config = function()
        math.randomseed(os.time())
    end,
}
