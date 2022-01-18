return {
    needs = { 'lewis6991/impatient.nvim' },
    after = { 'lewis6991/impatient.nvim' },
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
    },
}
