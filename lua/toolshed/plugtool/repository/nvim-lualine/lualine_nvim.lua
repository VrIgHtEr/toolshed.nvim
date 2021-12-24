return {
    needs = {'kyazdani42/nvim-tree.lua'},
    after = {'kyazdani42/nvim-tree.lua'},
    config = function()
        -- Color for highlights
        local colors = {
            yellow = '#ECBE7B',
            cyan = '#008080',
            darkblue = '#081633',
            green = '#98be65',
            orange = '#FF8800',
            violet = '#a9a1e1',
            magenta = '#c678dd',
            blue = '#51afef',
            red = '#ec5f67'
        }

        local config = {
            options = {
                icons_enabled = true,
                theme = 'iceberg_dark',
                component_separators = {'', ''},
                section_separators = {'', ''},
                disabled_filetypes = {}
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'filename'},
                lualine_c = {},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'location', 'branch'},
                lualine_z = {"os.date('%d/%m/%Y %H:%M:%S')"}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {}
        }

        -- Inserts a component in lualine_c at left section
        local function ins_left(component)
            table.insert(config.sections.lualine_c, component)
        end
        ins_left {
            'lsp_progress',
            -- With spinner
            -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
            colors = {
                percentage = colors.cyan,
                title = colors.cyan,
                message = colors.cyan,
                spinner = colors.cyan,
                lsp_client_name = colors.magenta,
                use = true
            },
            separators = {
                component = ' ',
                progress = ' | ',
                percentage = {pre = '', post = '%% '},
                title = {pre = '', post = ': '},
                lsp_client_name = {pre = '[', post = ']'},
                spinner = {pre = '', post = ''},
                message = {
                    pre = '(',
                    post = ')',
                    commenced = 'In Progress',
                    completed = 'Completed'
                }
            },
            display_components = {
                'lsp_client_name', 'spinner', {'title', 'percentage', 'message'}
            },
            timer = {
                progress_enddelay = 500,
                spinner = 1000,
                lsp_client_name_enddelay = 1000
            },
            spinner_symbols = {
                '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ',
                '🌘 '
            }
        }

        require('lualine').setup(config)

        local timer = vim.loop.new_timer()
        timer:start(1000, 1000, vim.schedule_wrap(require'lualine'.statusline))

    end
}
