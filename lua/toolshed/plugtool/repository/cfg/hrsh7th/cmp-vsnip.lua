return function(_, state)
    if not state['hrsh7th/nvim-cmp'] then state['hrsh7th/nvim-cmp'] = {} end
    state['hrsh7th/nvim-cmp']['vsnip'] = true
    if not state['hrsh7th/nvim-cmp']['snippet'] then
        state['hrsh7th/nvim-cmp']['snippet'] = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end
        }
    end
end
