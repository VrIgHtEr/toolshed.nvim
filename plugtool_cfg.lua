local constants = require 'plugtool.constants'
return {
    needs = { constants.mapx },
    after = { constants.cache_plugin_name, constants.mapx },
    config = {
        function()
            nnoremap('<leader>pu', ':lua require"plugtool-setup"()<cr>', 'silent', 'Update all plugins using plugtool')
        end,
        {
            function()
                local state = require('plugtool').state 'lukas-reineke/indent-blankline.nvim'
                if not state.excludedfiletypes then
                    state.excludedfiletypes = {}
                end
                table.insert(state.excludedfiletypes, 'plugtool')
            end,
            before = 'lukas-reineke/indent-blankline.nvim',
        },
    },
}
