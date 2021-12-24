return {
    needs = {"hrsh7th/nvim-cmp"},
    before = {"hrsh7th/nvim-cmp"},
    config = function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['buffer'] = true
    end
}
