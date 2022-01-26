return {
	needs = { "nvim-lua/plenary.nvim" },
	after = { "nvim-lua/plenary.nvim" },
	preload = function()
		vim.o.termguicolors = true
	end,
}
