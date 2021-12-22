return {
    function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['nvim_lsp'] = true
    end,
    {
        function() require('cmp_nvim_lsp').setup() end,
        before = "hrsh7th/nvim-cmp"
    }
}
