local testdata = {
    ['arkav/lualine-lsp-progress'] = {
        after = {"nvim-lualine/lualine.nvim", "neovim/nvim-lspconfig"},
        needs = {"nvim-lualine/lualine.nvim", "neovim/nvim-lspconfig"},
        reponame = "lualine-lsp-progress",
        username = "arkav"
    },
    ['kyazdani42/nvim-tree.lua'] = {
        after = {"kyazdani42/nvim-web-devicons"},
        needs = {"kyazdani42/nvim-web-devicons"},
        reponame = "nvim-tree.lua",
        username = "kyazdani42"
    },
    ['equalsraf/neovim-gui-shim'] = {
        reponame = "neovim-gui-shim",
        username = "equalsraf"
    },
    ['thehamsta/nvim-dap-virtual-text'] = {
        after = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"},
        needs = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"},
        reponame = "nvim-dap-virtual-text",
        username = "thehamsta"
    },
    ['nvim-telescope/telescope.nvim'] = {
        after = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
        needs = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
        reponame = "telescope.nvim",
        username = "nvim-telescope"
    },
    ['mfussenegger/nvim-jdtls'] = {
        after = {"mfussenegger/nvim-dap"},
        needs = {"mfussenegger/nvim-dap"},
        reponame = "nvim-jdtls",
        username = "mfussenegger"
    },
    ['folke/lua-dev.nvim'] = {
        after = {"neovim/nvim-lspconfig", "mfussenegger/nvim-dap"},
        needs = {"neovim/nvim-lspconfig", "mfussenegger/nvim-dap"},
        reponame = "lua-dev.nvim",
        username = "folke"
    },
    ['hrsh7th/nvim-cmp'] = {reponame = "nvim-cmp", username = "hrsh7th"},
    ['williamboman/nvim-lsp-installer'] = {
        after = {"neovim/nvim-lspconfig"},
        needs = {"neovim/nvim-lspconfig"},
        reponame = "nvim-lsp-installer",
        username = "williamboman"
    },
    ['airblade/vim-gitgutter'] = {
        reponame = "vim-gitgutter",
        username = "airblade"
    },
    ['hrsh7th/cmp-nvim-lsp'] = {
        after = {"neovim/nvim-lspconfig", "mfussenegger/nvim-dap"},
        before = {"hrsh7th/nvim-cmp"},
        needs = {
            "hrsh7th/nvim-cmp", "neovim/nvim-lspconfig", "mfussenegger/nvim-dap"
        },
        reponame = "cmp-nvim-lsp",
        username = "hrsh7th"
    },
    ['windwp/nvim-autopairs'] = {
        reponame = "nvim-autopairs",
        username = "windwp"
    },
    ['kyazdani42/nvim-web-devicons'] = {
        reponame = "nvim-web-devicons",
        username = "kyazdani42"
    },
    ['nathom/filetype.nvim'] = {reponame = "filetype.nvim", username = "nathom"},
    ['rcarriga/nvim-notify'] = {
        after = {"nvim-telescope/telescope.nvim"},
        needs = {"nvim-telescope/telescope.nvim"},
        reponame = "nvim-notify",
        username = "rcarriga"
    },
    ['ellisonleao/glow.nvim'] = {
        reponame = "glow.nvim",
        username = "ellisonleao"
    },
    ['hrsh7th/vim-vsnip'] = {reponame = "vim-vsnip", username = "hrsh7th"},
    ['nvim-lua/plenary.nvim'] = {
        reponame = "plenary.nvim",
        username = "nvim-lua"
    },
    ['rcarriga/nvim-dap-ui'] = {
        after = {"mfussenegger/nvim-dap"},
        needs = {"mfussenegger/nvim-dap"},
        reponame = "nvim-dap-ui",
        username = "rcarriga"
    },
    ['ray-x/aurora'] = {reponame = "aurora", username = "ray-x"},
    ['nvim-treesitter/nvim-treesitter'] = {
        reponame = "nvim-treesitter",
        username = "nvim-treesitter"
    },
    ['andrejlevkovitch/vim-lua-format'] = {
        reponame = "vim-lua-format",
        username = "andrejlevkovitch"
    },
    ['hrsh7th/cmp-path'] = {
        before = {"hrsh7th/nvim-cmp"},
        needs = {"hrsh7th/nvim-cmp"},
        reponame = "cmp-path",
        username = "hrsh7th"
    },
    ['nvim-lualine/lualine.nvim'] = {
        after = {"kyazdani42/nvim-tree.lua"},
        needs = {"kyazdani42/nvim-tree.lua"},
        reponame = "lualine.nvim",
        username = "nvim-lualine"
    },
    ['hrsh7th/cmp-vsnip'] = {
        after = {"hrsh7th/vim-vsnip"},
        before = {"hrsh7th/nvim-cmp"},
        needs = {"hrsh7th/nvim-cmp", "hrsh7th/vim-vsnip"},
        reponame = "cmp-vsnip",
        username = "hrsh7th"
    },
    ['vrighter/hue.nvim'] = {
        after = {"vrighter/toolshed.nvim", "rcarriga/nvim-notify"},
        needs = {"vrighter/toolshed.nvim", "rcarriga/nvim-notify"},
        reponame = "hue.nvim",
        username = "vrighter"
    },
    ['vrighter/toolshed.nvim'] = {
        after = {"rcarriga/nvim-notify"},
        needs = {"rcarriga/nvim-notify"},
        reponame = "toolshed.nvim",
        username = "vrighter"
    },
    ['mfussenegger/nvim-dap'] = {
        reponame = "nvim-dap",
        username = "mfussenegger"
    },
    ['Pocco81/DAPInstall.nvim'] = {
        after = {"mfussenegger/nvim-dap"},
        needs = {"mfussenegger/nvim-dap"},
        reponame = "DAPInstall.nvim",
        username = "Pocco81"
    },
    ['nvim-telescope/telescope-dap.nvim'] = {
        after = {
            "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap",
            "nvim-treesitter/nvim-treesitter"
        },
        needs = {
            "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap",
            "nvim-treesitter/nvim-treesitter"
        },
        reponame = "telescope-dap.nvim",
        username = "nvim-telescope"
    },
    ['hrsh7th/cmp-buffer'] = {
        before = {"hrsh7th/nvim-cmp"},
        needs = {"hrsh7th/nvim-cmp"},
        reponame = "cmp-buffer",
        username = "hrsh7th"
    },
    ['kosayoda/nvim-lightbulb'] = {
        reponame = "nvim-lightbulb",
        username = "kosayoda"
    },
    ['jbyuki/one-small-step-for-vimkind'] = {
        after = {"mfussenegger/nvim-dap"},
        needs = {"mfussenegger/nvim-dap"},
        reponame = "one-small-step-for-vimkind",
        username = "jbyuki"
    },
    ['jreybert/vimagit'] = {reponame = "vimagit", username = "jreybert"},
    ['hrsh7th/cmp-cmdline'] = {
        before = {"hrsh7th/nvim-cmp"},
        needs = {"hrsh7th/nvim-cmp"},
        reponame = "cmp-cmdline",
        username = "hrsh7th"
    },
    ['rafcamlet/nvim-luapad'] = {
        reponame = "nvim-luapad",
        username = "rafcamlet"
    },
    ['neovim/nvim-lspconfig'] = {
        reponame = "nvim-lspconfig",
        username = "neovim"
    }
}
local sort = function(plugs)
    for _, v in pairs(plugs) do
        local set = {}
        if v.before then
            for _, d in ipairs(v.before) do set[d] = true end
        end
        v.before = set
        set = {}
        if v.after then for _, d in ipairs(v.after) do set[d] = true end end
        v.after = set
    end
    for k, v in pairs(plugs) do
        local removed = {}
        for x in pairs(v.before) do
            if x == k then
                table.insert(removed, x)
            else
                local plug = plugs[x]
                if plug ~= nil then
                    plug.after[k] = true
                else
                    table.insert(removed, x)
                end
            end
        end
        for _, x in ipairs(removed) do v.before[x] = nil end

        removed = {}
        for x in pairs(v.after) do
            if x == k then
                table.insert(removed, x)
            else
                local plug = plugs[x]
                if plug ~= nil then
                    plug.before[k] = true
                else
                    table.insert(removed, x)
                end
            end
        end
        for _, x in ipairs(removed) do v.after[x] = nil end
    end

    local edges = {}
    local remaining = 0
    local sorted = {}
    for _, v in pairs(plugs) do
        if not pairs(v.before)(v.before) then
            table.insert(edges, v)
        else
            remaining = remaining + 1
        end
    end
    while #edges > 0 do
        local edge = table.remove(edges)
        table.insert(sorted, edge)
        local url = edge.username .. '/' .. edge.reponame
        for n in pairs(edge.after) do
            local plug = plugs[n]
            plug.before[url] = nil
            if not pairs(plug.before)(plug.before) then
                remaining = remaining - 1
                table.insert(edges, plug)
            end
        end
    end
    for _, v in pairs(plugs) do v.before = nil end
    if remaining ~= 0 then error "loops detected in dependency graph" end
    for i = 1, math.floor(#sorted / 2) do
        sorted[i], sorted[#sorted - i + 1] = sorted[#sorted - i + 1], sorted[i]
    end
    return sorted
end
sort(testdata)
return sort
