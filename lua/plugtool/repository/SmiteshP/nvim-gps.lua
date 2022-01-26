local gps = nil

return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-treesitter/nvim-treesitter' },
    before = { 'nvim-lualine/lualine.nvim' },
    config = {
        function()
            gps = require 'nvim-gps'
            gps.setup()
        end,
        {
            function()
                local config = require('plugtool').state 'nvim-lualine/lualine.nvim'
                if config.sections == nil then
                    config.sections = {}
                end
                local section = 'lualine_c'
                if config.sections[section] == nil then
                    config.sections[section] = {}
                end
                table.insert(config.sections[section], {
                    function()
                        local success, ret = pcall(require, 'nvim-gps')
                        if not success then
                            return ''
                        end
                        success, ret = pcall(ret.get_location)
                        if not success then
                            return ''
                        end
                        return ret
                    end,
                    cond = function()
                        local success, ret = pcall(require, 'nvim-gps')
                        if not success then
                            return false
                        end
                        success, ret = pcall(ret.is_available)
                        if not success then
                            return false
                        end
                        return ret
                    end,
                })
            end,
            before = 'nvim-lualine/lualine.nvim',
        },
    },
}
