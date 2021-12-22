return {
    ['hrsh7th/cmp-vsnip'] = {
        needs = {"hrsh7th/nvim-cmp", "hrsh7th/vim-vsnip"},
        before = {"hrsh7th/nvim-cmp"},
        after = {"hrsh7th/vim-vsnip"}
    },
    ['hrsh7th/cmp-cmdline'] = {
        needs = {"hrsh7th/nvim-cmp"},
        before = {"hrsh7th/nvim-cmp"}
    },
    ['hrsh7th/cmp-path'] = {
        needs = {"hrsh7th/nvim-cmp"},
        before = {"hrsh7th/nvim-cmp"}
    },
    ['hrsh7th/cmp-buffer'] = {
        needs = {"hrsh7th/nvim-cmp"},
        before = {"hrsh7th/nvim-cmp"}
    },
    ['hrsh7th/cmp-nvim-lsp'] = {
        needs = {
            "hrsh7th/nvim-cmp", "neovim/nvim-lspconfig", "mfussenegger/nvim-dap"
        },
        before = {"hrsh7th/nvim-cmp"},
        after = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'}
    },
    ['rcarriga/nvim-dap-ui'] = {
        needs = {"mfussenegger/nvim-dap"},
        after = {"mfussenegger/nvim-dap"}
    },
    ['thehamsta/nvim-dap-virtual-text'] = {
        needs = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"},
        after = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"}
    },
    ["Pocco81/DAPInstall.nvim"] = {
        needs = {"mfussenegger/nvim-dap"},
        after = {"mfussenegger/nvim-dap"}
    },
    ['kyazdani42/nvim-tree.lua'] = {
        needs = {"kyazdani42/nvim-web-devicons"},
        after = {"kyazdani42/nvim-web-devicons"}
    },
    ['rcarriga/nvim-notify'] = {
        needs = {"nvim-telescope/telescope.nvim"},
        after = {'nvim-telescope/telescope.nvim'}
    },
    ['mfussenegger/nvim-jdtls'] = {
        needs = {"mfussenegger/nvim-dap"},
        after = {'mfussenegger/nvim-dap'}
    },
    ['williamboman/nvim-lsp-installer'] = {
        needs = {'neovim/nvim-lspconfig', "rcarriga/nvim-notify"},
        after = {'neovim/nvim-lspconfig', "rcarriga/nvim-notify"}
    },
    ['jbyuki/one-small-step-for-vimkind'] = {
        needs = {'mfussenegger/nvim-dap'},
        after = {'mfussenegger/nvim-dap'}
    },
    ["folke/lua-dev.nvim"] = {
        needs = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'},
        after = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'}
    },
    ['nvim-lualine/lualine.nvim'] = {
        needs = {'kyazdani42/nvim-tree.lua'},
        after = {'kyazdani42/nvim-tree.lua'}
    },
    ['arkav/lualine-lsp-progress'] = {
        needs = {"nvim-lualine/lualine.nvim", 'neovim/nvim-lspconfig'},
        after = {"nvim-lualine/lualine.nvim", 'neovim/nvim-lspconfig'}
    },
    ['nvim-telescope/telescope.nvim'] = {
        needs = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'},
        after = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'}
    },
    ['nvim-telescope/telescope-dap.nvim'] = {
        needs = {
            'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap',
            'nvim-treesitter/nvim-treesitter'
        },
        after = {
            'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap',
            'nvim-treesitter/nvim-treesitter'
        }
    },
    ['nvim-telescope/telescope-packer.nvim'] = {
        needs = {'wbthomason/packer.nvim', 'nvim-telescope/telescope.nvim'},
        after = {'wbthomason/packer.nvim', 'nvim-telescope/telescope.nvim'}
    },
    ['andrejlevkovitch/vim-lua-format'] = {
        needs = {"rcarriga/nvim-notify"},
        after = {"rcarriga/nvim-notify"}
    },
    ['neovim/nvim-lspconfig'] = {
        needs = {"rcarriga/nvim-notify"},
        after = {"rcarriga/nvim-notify"}
    }
}