local a = require 'toolshed.async'
local plugtool = require 'toolshed.plugtool'
a.run(function()
    -- a.spawn_a({'rm', '-rf', '/home/cedric/.local/share/nvim/env/opt/plugtool'})
    a.main_loop()
    plugtool.setup {
        "vrighter/hue.nvim", 'hrsh7th/cmp-vsnip', 'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp',
        'rcarriga/nvim-dap-ui', 'thehamsta/nvim-dap-virtual-text',
        "Pocco81/DAPInstall.nvim", 'equalsraf/neovim-gui-shim',
        'kosayoda/nvim-lightbulb', 'windwp/nvim-autopairs', 'ray-x/aurora',
        "nathom/filetype.nvim", "ellisonleao/glow.nvim",
        'airblade/vim-gitgutter', 'jreybert/vimagit', 'mfussenegger/nvim-jdtls',
        'williamboman/nvim-lsp-installer', 'jbyuki/one-small-step-for-vimkind',
        'andrejlevkovitch/vim-lua-format', "rafcamlet/nvim-luapad",
        "folke/lua-dev.nvim", 'nvim-telescope/telescope-dap.nvim',
        'arkav/lualine-lsp-progress'
    }
end)
