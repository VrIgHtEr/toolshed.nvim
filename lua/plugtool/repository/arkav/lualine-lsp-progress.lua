return {
    plugin_type = require('plugtool.constants').type.gui,
    needs = { 'nvim-lualine/lualine.nvim', 'neovim/nvim-lspconfig' },
    before = { 'nvim-lualine/lualine.nvim' },
    config = {
        {
            function()
                local config = require('plugtool').state 'nvim-lualine/lualine.nvim'
                if config.sections == nil then
                    config.sections = {}
                end
                if config.sections.lualine_c == nil then
                    config.sections.lualine_c = {}
                end
                local colors = {
                    yellow = '#ECBE7B',
                    cyan = '#008080',
                    darkblue = '#081633',
                    green = '#98be65',
                    orange = '#FF8800',
                    violet = '#a9a1e1',
                    magenta = '#c678dd',
                    blue = '#51afef',
                    red = '#ec5f67',
                }
                table.insert(config.sections.lualine_c, {
                    'lsp_progress',
                    -- With spinner
                    -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
                    colors = {
                        percentage = colors.cyan,
                        title = colors.cyan,
                        message = colors.cyan,
                        spinner = colors.cyan,
                        lsp_client_name = colors.magenta,
                        use = true,
                    },
                    separators = {
                        component = ' ',
                        progress = ' | ',
                        percentage = { pre = '', post = '%% ' },
                        title = { pre = '', post = ': ' },
                        lsp_client_name = { pre = '[', post = ']' },
                        spinner = { pre = '', post = '' },
                        message = {
                            pre = '(',
                            post = ')',
                            commenced = 'In Progress',
                            completed = 'Completed',
                        },
                    },
                    display_components = {
                        'lsp_client_name',
                        'spinner',
                        { 'title', 'percentage', 'message' },
                    },
                    timer = {
                        progress_enddelay = 500,
                        spinner = 1000,
                        lsp_client_name_enddelay = 1000,
                    },
                    spinner_symbols = {
                        '🌑 ',
                        '🌒 ',
                        '🌓 ',
                        '🌔 ',
                        '🌕 ',
                        '🌖 ',
                        '🌗 ',
                        '🌘 ',
                    },
                })
            end,
            before = 'nvim-lualine/lualine.nvim',
        },
    },
}
