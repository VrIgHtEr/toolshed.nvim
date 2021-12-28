local display = {}
local buf = 0

function display.new()
    local win = vim.api.nvim_get_current_win()
    if buf ~= 0 then
        vim.api.nvim_buf_delete(buf, {force = true})
        buf = 0
    end
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    local maxline = 0
    local plugins = {}
    local displayers = {}

    local function get_last_line()
        if #displayers == 0 then
            return 0
        else
            return displayers[#displayers].get_next_line()
        end
    end

    local function make_displayer()
        maxline = maxline + 1
        local index = maxline
        local lines = {}
        local displayer = {}
        local lineindex = get_last_line()
        displayers[index] = displayer

        function displayer.message(str)
            vim.schedule(function()
                local newlines = {}
                for x in str:lines() do table.insert(newlines, x) end
                local last_line = get_last_line()
                local redraw_following = #lines ~= #newlines
                lines = newlines
                displayer.redraw()
                if redraw_following then
                    local prev = displayer
                    for x = index + 1, #displayers do
                        displayers[x].set_line_index(prev.get_next_line())
                        prev = displayers[x]
                        prev.redraw()
                    end
                    local new_last_line = get_last_line()
                    if new_last_line < last_line then
                        vim.api.nvim_buf_set_lines(buf, new_last_line,
                                                   last_line, false, {})
                    end
                end
            end)
        end

        function displayer.get_next_line() return lineindex + #lines end
        function displayer.set_line_index(idx) lineindex = idx end
        function displayer.redraw()
            vim.api.nvim_buf_set_lines(buf, lineindex,
                                       displayer.get_next_line(), false, lines)
        end
        return displayer.message
    end

    return {
        close = function()
            vim.schedule(function()
                if buf ~= 0 then
                    vim.api.nvim_buf_delete(buf, {force = true})
                    buf = 0
                end
            end)
        end,
        displayer = function(url)
            if not plugins[url] then plugins[url] = make_displayer() end
            return plugins[url]
        end
    }
end
return display
