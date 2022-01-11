return {
    needs = {'nvim-telescope/telescope.nvim'},
    before = {'nvim-telescope/telescope.nvim'},
    config = {
        {
            function(_, state)

                local st = state["nvim-telescope/telescope.nvim"]
                if st == nil then
                    st = {}
                    state["nvim-telescope/telescope.nvim"] = st
                end
                if st.extensions == nil then st.extensions = {} end
                st.extensions["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }
                }
            end,
            before = "nvim-telescope/telescope.nvim"
        }, {
            function()
                require("telescope").load_extension("ui-select")
            end,
            after = "nvim-telescope/telescope.nvim"
        }
    }
}
