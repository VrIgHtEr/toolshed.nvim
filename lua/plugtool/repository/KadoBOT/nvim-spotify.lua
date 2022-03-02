return {
    needs = { 'nvim-telescope/telescope.nvim' },
    after = { 'nvim-telescope/telescope.nvim' },
    config = {
        function()
            local spotify = require 'nvim-spotify'
            spotify.setup {
                status = {
                    update_interval = 10000,
                    format = '%s %t by %a',
                },
            }
        end,
    },
    setup = { 'make' },
}
