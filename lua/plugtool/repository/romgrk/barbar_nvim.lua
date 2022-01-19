return {
    needs = { 'kyazdani42/nvim-web-devicons' },
    after = { 'kyazdani42/nvim-web-devicons' },
    preload = function()
        vim.o.termguicolors = true
        vim.g.bufferline = {
            -- Enable/disable animations
            animation = true,

            -- Enable/disable auto-hiding the tab bar when there is a single buffer
            auto_hide = false,

            -- Enable/disable current/total tabpages indicator (top right corner)
            tabpages = true,

            -- Enable/disable close button
            closable = true,

            -- Enables/disable clickable tabs
            --  - left-click: go to buffer
            --  - middle-click: delete buffer
            clickable = true,

            -- Excludes buffers from the tabline
            exclude_ft = { 'javascript' },
            exclude_name = { 'package.json' },

            -- Enable/disable icons
            -- if set to 'numbers', will show buffer index in the tabline
            -- if set to 'both', will show buffer index and icons in the tabline
            icons = true,

            -- If set, the icon color will follow its corresponding buffer
            -- highlight group. By default, the Buffer*Icon group is linked to the
            -- Buffer* group (see Highlighting below). Otherwise, it will take its
            -- default value as defined by devicons.
            icon_custom_colors = false,

            -- Configure icons on the bufferline.
            icon_separator_active = '▎',
            icon_separator_inactive = '▎',
            icon_close_tab = '',
            icon_close_tab_modified = '●',
            icon_pinned = '車',

            -- If true, new buffers will be inserted at the start/end of the list.
            -- Default is to insert after current buffer.
            insert_at_end = false,
            insert_at_start = false,

            -- Sets the maximum padding width with which to surround each tab
            maximum_padding = 1,

            -- Sets the maximum buffer name length.
            maximum_length = 30,

            -- If set, the letters for each buffer in buffer-pick mode will be
            -- assigned based on their name. Otherwise or in case all letters are
            -- already assigned, the behavior is to assign letters in order of
            -- usability (see order below)
            semantic_letters = true,

            -- New buffer letters are assigned in this order. This order is
            -- optimal for the qwerty keyboard layout but might need adjustement
            -- for other layouts.
            letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

            -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
            -- where X is the buffer number. But only a static string is accepted here.
            no_name_title = nil,
        }
    end,
    config = {
        {
            function()
                local nnoremap = _G['nnoremap']

                -- Move to previous/next
                nnoremap('<A-,>', ':BufferPrevious<CR>', 'silent', 'Switch to previous buffer')
                nnoremap('<A-.>', ':BufferNext<CR>', 'silent', 'Switch to next buffer')
                -- Re-order to previous/next
                nnoremap('<A-<>', ':BufferMovePrevious<CR>', 'silent', 'Move buffer to the left')
                nnoremap('<A->>', ' :BufferMoveNext<CR>', 'silent', 'Move buffer to the right')
                -- Goto buffer in position...
                nnoremap('<A-1>', ':BufferGoto 1<CR>', 'silent', 'Switch to buffer 1')
                nnoremap('<A-2>', ':BufferGoto 2<CR>', 'silent', 'Switch to buffer 2')
                nnoremap('<A-3>', ':BufferGoto 3<CR>', 'silent', 'Switch to buffer 3')
                nnoremap('<A-4>', ':BufferGoto 4<CR>', 'silent', 'Switch to buffer 4')
                nnoremap('<A-5>', ':BufferGoto 5<CR>', 'silent', 'Switch to buffer 5')
                nnoremap('<A-6>', ':BufferGoto 6<CR>', 'silent', 'Switch to buffer 6')
                nnoremap('<A-7>', ':BufferGoto 7<CR>', 'silent', 'Switch to buffer 7')
                nnoremap('<A-8>', ':BufferGoto 8<CR>', 'silent', 'Switch to buffer 8')
                nnoremap('<A-9>', ':BufferGoto 9<CR>', 'silent', 'Switch to buffer 9')
                nnoremap('<A-0>', ':BufferLast<CR>', 'silent', 'Switch to last buffer')
                -- Close buffer
                nnoremap('<A-c>', ':BufferClose<CR>', 'silent', 'Close current buffer')
                -- Wipeout buffer
                --                 :BufferWipeout<CR>
                -- Close commands
                --                 :BufferCloseAllButCurrent<CR>
                --                 :BufferCloseBuffersLeft<CR>
                --                 :BufferCloseBuffersRight<CR>
                -- Magic buffer-picking mode
                nnoremap('<C-p>', ':BufferPick<CR>', 'silent', 'Select buffer')
                -- Sort automatically by...
                nnoremap('<Space>bb', ':BufferOrderByBufferNumber<CR>', 'silent', 'Sort buffers by buffer number')
                nnoremap('<Space>bd', ':BufferOrderByDirectory<CR>', 'silent', 'Sort buffers by directory')
                nnoremap('<Space>bl', ':BufferOrderByLanguage<CR>', 'silent', 'Sort buffers by language')
            end,
            after = 'b0o/mapx.nvim',
        },
    },
}
