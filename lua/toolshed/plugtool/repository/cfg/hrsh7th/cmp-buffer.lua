return {
    function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['buffer'] = true
    end, {
        function()
            require('cmp').register_source('buffer', require('cmp_buffer'))
        end,
        before = "hrsh7th/nvim-cmp"
    }
}
