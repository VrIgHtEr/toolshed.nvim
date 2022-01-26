return {
    needs = { 'mfussenegger/nvim-dap', 'sidebar-nvim/sidebar.nvim' },
    after = { 'mfussenegger/nvim-dap' },
    before = { 'sidebar-nvim/sidebar.nvim' },
    config = {
        {
            function()
                local state = require('plugtool').state 'sidebar-nvim/sidebar.nvim'
                if not state.sections then
                    state.sections = {}
                end
                table.insert(state.sections, require 'dap-sidebar-nvim.breakpoints')
            end,
            before = 'sidebar-nvim/sidebar.nvim',
        },
    },
}
