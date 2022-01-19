return {
	preload = function()
		vim.o.termguicolors = true
	end,
	config = function()
		math.randomseed(os.time())
	end,
}
