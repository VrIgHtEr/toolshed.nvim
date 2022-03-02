return {
    needs = { 'nvim-telescope/telescope.nvim' },
    after = { 'nvim-telescope/telescope.nvim' },
    before = { 'nvim-lualine/lualine.nvim' },
    config = {
        function()
            local spotify = require 'nvim-spotify'
            spotify.setup {
                status = {
                    update_interval = 10000,
                    format = '%s %t by %a',
                },
            }
            nnoremap('<leader><leader>n', '<Plug>(SpotifySkip)', 'silent', 'Spotify: Skip')
            nnoremap('<leader><leader>p', '<Plug>(SpotifyPause)', 'silent', 'Spotify: Play/Pause')
            nnoremap('<leader><leader>s', '<Plug>(SpotifySave)', 'silent', 'Spotify: Add to library')
            nnoremap('<leader><leader>o', ':Spotify<CR>', 'silent', 'Spotify: Search')
            nnoremap('<leader><leader>d', ':SpotifyDevices<CR>', 'silent', 'Spotify: Devices')
            nnoremap('<leader><leader>b', '<Plug>(SpotifyPrev)', 'silent', 'Spotify: Previous')
        end,
        {
            before = 'nvim-lualine/lualine.nvim',
            function()
                local config = require('plugtool').state 'nvim-lualine/lualine.nvim'
                if config.sections == nil then
                    config.sections = {}
                end
                if config.sections.lualine_x == nil then
                    config.sections.lualine_x = {}
                end
                table.insert(config.sections.lualine_x, 1, require('nvim-spotify').status.listen)
            end,
        },
        {
            after = 'nvim-lualine/lualine.nvim',
            function()
                require('nvim-spotify').status:start()
            end,
        },
    },
    setup = { 'make' },
}
