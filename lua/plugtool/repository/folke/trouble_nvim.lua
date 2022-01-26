return {
	needs = { "kyazdani42/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	after = { "kyazdani42/nvim-web-devicons", "folke/lsp-colors.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		require("trouble").setup({})
		local actions = require("telescope.actions")
		local trouble = require("trouble.providers.telescope")

		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<c-t>"] = trouble.open_with_trouble },
					n = { ["<c-t>"] = trouble.open_with_trouble },
				},
			},
		})
	end,
	preload = function()
		vim.o.termguicolors = true
	end,
}
