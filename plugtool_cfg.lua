return {
    config = {
        {
            function()
                local state = require('plugtool').state 'lukas-reineke/indent-blankline.nvim'
                if not state.excludedfiletypes then
                    state.excludedfiletypes = {}
                end
                table.insert(state.excludedfiletypes, 'plugtool')
            end,
            before = 'likas-reineke/indent-blankline.nvim',
        },
        {
            function()
                nnoremap('<leader>pu', ':lua require"plugtool-setup"()<cr>', 'silent', 'Update all plugins using plugtool')
            end,
            after = 'b0o/mapx.nvim',
        },
    },
}
