return {
    needs = { 'neovim/nvim-lspconfig' },
    after = { 'neovim/nvim-lspconfig' },
    config = {
        function()
            local navic = require 'nvim-navic'
            navic.setup {}
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
                        local success, ret = pcall(require, 'nvim-navic')
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
                        local success, ret = pcall(require, 'nvim-navic')
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
