local quotes = require 'plugtool.repository.startup-nvim._quotes'
local function quote()
    return quotes[math.floor(math.random() * #quotes) + 1]
end

return {
    needs = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    after = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
        'lukas-reineke/indent-blankline.nvim',
    },
    config = {
        function()
            require('plugtool').set_startup_func(function()
                math.randomseed(os.clock())
                local settings = {
                    -- every line should be same width without escaped \
                    header = {
                        type = 'text',
                        align = 'center',
                        fold_section = false,
                        title = 'Header',
                        margin = 5,
                        content = require 'plugtool.header',
                        highlight = 'Statement',
                        default_color = '',
                        oldfiles_amount = 0,
                    },
                    header_2 = {
                        type = 'text',
                        oldfiles_directory = false,
                        align = 'center',
                        fold_section = false,
                        title = 'Quote',
                        margin = 5,
                        content = quote(),
                        highlight = 'Constant',
                        default_color = '',
                        oldfiles_amount = 0,
                    },
                    -- name which will be displayed and command
                    body = {
                        type = 'mapping',
                        align = 'center',
                        fold_section = true,
                        title = 'Basic Commands',
                        margin = 5,
                        content = {
                            { ' Find File', 'Telescope find_files', '<leader>ff' },
                            { ' Find Word', 'Telescope live_grep', '<leader>lg' },
                            { ' Recent Files', 'Telescope oldfiles', '<leader>of' },
                            { ' File Browser', 'Telescope file_browser', '<leader>fb' },
                            { ' Colorschemes', 'Telescope colorscheme', '<leader>cs' },
                            { ' New File', "lua require'startup'.new_file()", '<leader>nf' },
                        },
                        highlight = 'String',
                        default_color = '',
                        oldfiles_amount = 0,
                    },
                    body_2 = {
                        type = 'oldfiles',
                        oldfiles_directory = true,
                        align = 'center',
                        fold_section = true,
                        title = 'Oldfiles of Directory',
                        margin = 5,
                        content = {},
                        highlight = 'String',
                        default_color = '#FFFFFF',
                        oldfiles_amount = 5,
                    },
                    footer = {
                        type = 'oldfiles',
                        oldfiles_directory = false,
                        align = 'center',
                        fold_section = true,
                        title = 'Oldfiles',
                        margin = 5,
                        content = { 'startup.nvim' },
                        highlight = 'TSString',
                        default_color = '#FFFFFF',
                        oldfiles_amount = 5,
                    },

                    clock = {
                        type = 'text',
                        content = function()
                            local clock = ' ' .. os.date '%H:%M'
                            local date = ' ' .. os.date '%d-%m-%y'
                            return { clock, date }
                        end,
                        oldfiles_directory = false,
                        align = 'center',
                        fold_section = false,
                        title = '',
                        margin = 5,
                        highlight = 'TSString',
                        default_color = '#FFFFFF',
                        oldfiles_amount = 10,
                    },

                    footer_2 = {
                        type = 'text',
                        content = { 'Plugins loaded (plugtool): ' .. #(require('plugtool').loaded()) },
                        oldfiles_directory = false,
                        align = 'center',
                        fold_section = false,
                        title = '',
                        margin = 5,
                        highlight = 'TSString',
                        default_color = '#FFFFFF',
                        oldfiles_amount = 10,
                    },

                    options = {
                        after = function()
                            require('startup.utils').oldfiles_mappings()
                        end,
                        mapping_keys = true,
                        cursor_column = 0.5,
                        empty_lines_between_mappings = true,
                        disable_statuslines = true,
                        paddings = { 2, 2, 2, 2, 2, 2, 2 },
                    },
                    colors = {
                        background = '#1f2227',
                        folded_section = '#56b6c2',
                    },
                    parts = {
                        'header',
                        'header_2',
                        'body',
                        'body_2',
                        'footer',
                        'clock',
                        'footer_2',
                    },
                }
                --            settings = require 'startup.themes.dashboard'
                --            settings.header.content = require 'plugtool.header'
                --            settings.header.highlight = 'String'
                --            settings.footer.content = { '' }

                require('startup').setup(settings)
            end)
        end,
        {
            function()
                local state = require('plugtool').state 'lukas-reineke/indent-blankline.nvim'
                if not state.excludedfiletypes then
                    state.excludedfiletypes = {}
                end
                table.insert(state.excludedfiletypes, 'startup')
            end,
            before = 'lukas-reineke/indent-blankline.nvim',
        },
    },
}
