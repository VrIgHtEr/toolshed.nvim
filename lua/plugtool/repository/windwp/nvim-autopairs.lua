return {
    plugin_type = require('plugtool.constants').type.dev,
    config = function()
        require('nvim-autopairs').setup {}
    end,
}
