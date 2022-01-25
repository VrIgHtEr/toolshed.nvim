return {
    plugin_type = require('plugtool.constants').type.sys_override,
    needs = { 'nvim-telescope/telescope.nvim' },
    before = { 'nvim-telescope/telescope.nvim' },
    config = {
        {
            function()
                local st = require('plugtool').state 'nvim-telescope/telescope.nvim'
                if st.extensions == nil then
                    st.extensions = {}
                end
                st.extensions['ui-select'] = {
                    require('telescope.themes').get_dropdown {
                        -- even more opts
                    },
                }
            end,
            before = 'nvim-telescope/telescope.nvim',
        },
        {
            function()
                require('telescope').load_extension 'ui-select'
            end,
            after = 'nvim-telescope/telescope.nvim',
        },
    },
}
