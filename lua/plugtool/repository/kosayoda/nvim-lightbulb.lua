return {
	config = function()
		vim.cmd([[augroup nvimlightbulb
            au!
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            augroup end]])
	end,
	preload = function()
		vim.o.termguicolors = true
	end,
}
