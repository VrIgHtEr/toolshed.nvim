return {
    needs = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    after = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
        'lukas-reineke/indent-blankline.nvim',
    },
    config = {
        function()
            local settings = require 'startup.themes.dashboard'
            settings.header.content = {
                '▄▄▄▄▄▄▄  ▄    ▄▄    ▄ ▄  ▄▄▄ ▄ ▄▄ ▄▄▄▄▄▄▄',
                '█ ▄▄▄ █ ▀▄ ▀▄▄ ▄█ ▄ ▀ ▀▀ ▄ █ ▄  ▀ █ ▄▄▄ █',
                '█ ███ █ ▀ ▀           ▄     ▄  ▄  █ ███ █',
                '█▄▄▄▄▄█ █ █ ▄▀█▀▄ ▄▀▄ ▄ ▄ ▄▀▄▀▄▀▄ █▄▄▄▄▄█',
                '▄▄▄▄▄ ▄▄▄▀  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ▀▄ ▄ ▄ ▄ ',
                ' █▄▄ ▄▄▀  ▄█████████████████████▄   ▄▄ ▀█',
                ' ▀    ▄ ▄█████████████████████████▄  ▄▀  ',
                '▄     ▄ ███████████████████████████  █ ▀▀',
                '▀ ▀▀ ▄▄ █████▀   ▀███████▀   ▀█████  █▄▀ ',
                '▀ ▄▄▀ ▄ ████       █████       ████ ▄▄█  ',
                '  ▀▀  ▄ ████▄     ▄█████▄     ▄████  ▄   ',
                '▀█   █▄ ██████▄▄▄████▀████▄▄▄██████    ▄ ',
                '▄  ▄▀ ▄ ███████████▀▀ ▀▀███████████    ▀▄',
                ' ▄▄▄ ▄▄  ▀█████████▄▄▄▄▄█████████▀ ▄▀█ ▄ ',
                ' █ ▄  ▄    █████████████████████  ▄▄ ▄▀ ▀',
                '  ▀▀  ▄▄ ▀ ███ ██ ███ ███ ██ ███ ▀█  ▀▄█▀',
                '  ▄  ▄▄▄▄▀ ███ ██ ███ ███ ██ ███▄█▄▄▄▄▄▀ ',
                '▄▄▄▄▄▄▄ █▀ ▀█████ ███ ███ █████▀█ ▄ █  ▀▄',
                '█ ▄▄▄ █ ▄▀ ▄ ▀███████████████▀  █▄▄▄█    ',
                '█ ███ █ █ ▀▄   ▀▀▀▀▀▀▀▀▀▀▀▀▀ ▄ ▀█ ▄▀  ▀█ ',
                '█▄▄▄▄▄█ █ ▄    ▄▄ ▀  ▄▄▄▄ ▄▀  ▀▀  ▄▄▀  █▀',
            }
            settings.header.highlight = 'String'
            settings.footer.content = { '' }
            require('startup').setup(settings)
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
