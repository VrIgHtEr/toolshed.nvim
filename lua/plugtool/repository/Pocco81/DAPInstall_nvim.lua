return {
    needs = { 'mfussenegger/nvim-dap' },
    after = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap_install = require 'dap-install'
        dap_install.setup {
            installation_path = require('toolshed.env').opt .. '/dap/',
        }
        local dbg_list = require('dap-install.api.debuggers').get_installed_debuggers()

        for _, debugger in ipairs(dbg_list) do
            dap_install.config(debugger)
        end
    end,
}
