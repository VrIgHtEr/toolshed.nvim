return {
    needs = { 'nvim-telescope/telescope.nvim', 'b0o/mapx.nvim' },
    after = { 'nvim-telescope/telescope.nvim', 'ray-x/aurora', 'b0o/mapx.nvim' },
    config = function()
        require('notify').setup {
            -- Animation style (see below for details)
            stages = 'slide',

            -- Function called when a new window is opened, use for changing win settings/config
            on_open = nil,

            -- Render function for notifications. See notify-render()
            render = 'default',

            -- Default timeout for notifications
            timeout = 5000,

            -- For stages that change opacity this is treated as the highlight behind the window
            -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
            background_colour = 'Normal',

            -- Minimum width for notification windows
            minimum_width = 50,

            -- Icons for the different levels
            icons = {
                ERROR = '',
                WARN = '',
                INFO = '',
                DEBUG = '',
                TRACE = '✎',
            },
        }
        vim.notify = require 'notify'
        nnoremap('<leader>nn', ':Telescope notify<cr>', 'silent', 'Telescope: Show a list of previously shown notifications')
    end,
}
