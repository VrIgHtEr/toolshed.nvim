local constants = require 'plugtool.constants'
return {
    plugin_type = constants.type.plugtool,
    needs = { constants.mapx },
    config = {
        function()
            nnoremap('<leader>pu', ':lua require"plugtool".update()<cr>', 'silent', 'Update all plugins using plugtool')
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
