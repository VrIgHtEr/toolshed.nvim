return {
    needs = { 'lewis6991/impatient.nvim', 'b0o/mapx.nvim' },
    after = { 'lewis6991/impatient.nvim', 'b0o/mapx.nvim' },
    config = {
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
        {
            function()
                nnoremap('<leader>pu', ':lua require"plugtool-setup"()<cr>', 'silent', 'Update all plugins using plugtool')
            end,
            after = 'b0o/mapx.nvim',
        },
    },
}
