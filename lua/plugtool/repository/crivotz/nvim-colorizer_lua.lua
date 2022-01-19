return {
	config = function()
		require("colorizer").setup()
	end,
	preload = function()
		vim.o.termguicolors = true
	end,
}
