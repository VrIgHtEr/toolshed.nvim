return {
    function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['path'] = true
    end, {
        function()
            require('cmp').register_source('path', require('cmp_path').new())
        end,
        before = "hrsh7th/nvim-cmp"
    }
}
