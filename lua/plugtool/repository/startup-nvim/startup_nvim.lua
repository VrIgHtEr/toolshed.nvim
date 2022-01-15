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
            require('startup').setup(settings)
        end,
        {
            function()
                vim.api.nvim_exec(
                    [[augroup indentblanklineplugtoolaugroup
              autocmd!
              autocmd BufEnter startup :IndentBlanklineDisable
              autocmd BufLeave startup :IndentBlanklineEnable
              autocmd FileType startup :IndentBlanklineDisable
          augroup end]],
                    true
                )
            end,
            after = 'lukas-reineke/indent-blankline.nvim',
        },
    },
}
