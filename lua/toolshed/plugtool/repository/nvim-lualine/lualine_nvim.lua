return {
    needs = { 'kyazdani42/nvim-tree.lua' },
    after = { 'kyazdani42/nvim-tree.lua' },
    config = function(plugins)
        -- Color for highlights
        local config = {
            options = {
                icons_enabled = true,
                theme = 'iceberg_dark',
                component_separators = { '', '' },
                section_separators = { '', '' },
                disabled_filetypes = {},
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'filename' },
                lualine_c = {},
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'location', 'branch' },
                lualine_z = { "os.date('%d/%m/%Y %H:%M:%S')" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = {},
        }

        local state = require('toolshed.plugtool').state 'nvim-lualine/lualine.nvim'

        if state.sections then
            if state.sections.lualine_a then
                for _, x in ipairs(state.sections.lualine_a) do
                    table.insert(config.sections.lualine_a, x)
                end
                for _, x in ipairs(state.sections.lualine_b) do
                    table.insert(config.sections.lualine_b, x)
                end
                for _, x in ipairs(state.sections.lualine_c) do
                    table.insert(config.sections.lualine_c, x)
                end
                for _, x in ipairs(state.sections.lualine_x) do
                    table.insert(config.sections.lualine_x, x)
                end
                for _, x in ipairs(state.sections.lualine_y) do
                    table.insert(config.sections.lualine_y, x)
                end
                for _, x in ipairs(state.sections.lualine_z) do
                    table.insert(config.sections.lualine_z, x)
                end
            end
        end
        require('lualine').setup(config)

        local timer = vim.loop.new_timer()
        timer:start(1000, 1000, vim.schedule_wrap(require('lualine').statusline))
    end,
}
