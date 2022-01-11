return {
    needs = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'},
    after = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'},
    config = function(_, state)
        local st = state["nvim-telescope/telescope.nvim"]
        local cfg = {}
        if st ~= nil then cfg.extensions = st.extensions end
        require'telescope'.setup(cfg)
    end
}
