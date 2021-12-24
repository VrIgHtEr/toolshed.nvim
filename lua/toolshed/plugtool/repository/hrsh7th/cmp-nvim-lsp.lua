return {
    needs = {
        "hrsh7th/nvim-cmp", "neovim/nvim-lspconfig", "mfussenegger/nvim-dap"
    },
    before = {"hrsh7th/nvim-cmp"},
    after = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'},
    config = function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['nvim_lsp'] = true
    end
}
