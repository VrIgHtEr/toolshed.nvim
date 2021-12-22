return {
    function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['cmdline'] = true
    end, {
        function()
            require('cmp').register_source('cmdline',
                                           require('cmp_cmdline').new())
        end,
        before = "hrsh7th/nvim-cmp"
    }
}
