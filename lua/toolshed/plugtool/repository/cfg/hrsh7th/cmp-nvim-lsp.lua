return function(plugs, state)
    if not state['hrsh7th/nvim-cmp'] then state['hrsh7th/nvim-cmp'] = {} end
    state['hrsh7th/nvim-cmp']['nvim_lsp'] = true
end
