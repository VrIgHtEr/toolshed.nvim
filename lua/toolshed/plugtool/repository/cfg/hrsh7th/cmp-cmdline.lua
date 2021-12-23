return function(_, state)
    if not state['hrsh7th/nvim-cmp'] then state['hrsh7th/nvim-cmp'] = {} end
    state['hrsh7th/nvim-cmp']['cmdline'] = true
end
