return {
    needs = {"mfussenegger/nvim-dap"},
    after = {"mfussenegger/nvim-dap"},
    config = function()
        local dap_install = require("dap-install")
        dap_install.setup({
            installation_path = require'toolshed.env'.opt .. "/dap/"
        })
    end
}
