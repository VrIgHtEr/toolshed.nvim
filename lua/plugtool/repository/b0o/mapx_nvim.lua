return {
    plugin_type = require('plugtool.constants').type.global,
    after = { 'folke/which-key.nvim' },
    config = function(plugins)
        local config = { global = true }
        if plugins['folke/which-key.nvim'] then
            config.whichkey = true
        end
        require('mapx').setup(config)
    end,
}
