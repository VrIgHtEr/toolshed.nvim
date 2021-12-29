local display = {}
local buf = 0
local separator = ' : '
local separator_length = separator:len()

function display.new()
    local win = vim.api.nvim_get_current_win()
    if buf ~= 0 then
        vim.api.nvim_buf_delete(buf, {force = true})
        buf = 0
    end
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    local urlwidth = 0
    local maxline = 0
    local plugins = {}
    local displayers = {}
    local redraw_all = false
    local emptypadding = ""

    local function get_last_line()
        if #displayers == 0 then
            return 0
        else
            return displayers[#displayers].get_next_line()
        end
    end

    local function make_displayer(url)
        local name = url
        local nsname = "toolshed.plugtool.display/" .. name
        local ns = nil
        maxline = maxline + 1
        local index = maxline
        local lines = {}
        local displayer = {}
        local lineindex = get_last_line()
        displayers[index] = displayer
        local message = ""
        local changelogs = {}

        function displayer.padurl()
            local len = url:len()
            while len < urlwidth do
                url = url .. ' '
                len = len + 1
            end
        end

        local function create_lines()
            local newlines = {}
            for x in message:lines() do table.insert(newlines, x) end
            for _, x in ipairs(changelogs) do
                table.insert(newlines, '- ' .. x.hash:sub(1, 8) .. ' - ' ..
                                 x.time .. ' - ' .. x.message)
            end
            if #newlines == 0 then table.insert(newlines, "") end
            if #newlines > 1 then table.insert(newlines, "") end
            newlines[1] = url .. separator .. newlines[1]
            for i = 2, #newlines do
                newlines[i] = emptypadding .. newlines[i]
            end
            return newlines
        end

        function displayer.message(str, changes)
            vim.schedule(function()
                changelogs = changes or {}
                message = str
                local newlines = create_lines()
                local last_line = get_last_line()
                local redraw_following = redraw_all or (#lines ~= #newlines)
                lines = newlines

                local prev
                if redraw_all then
                    prev = displayers[1]
                    redraw_all = false
                else
                    prev = displayer
                end
                prev.redraw()
                if redraw_following then
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
            if not ns then ns = vim.api.nvim_create_namespace(nsname) end
            vim.api.nvim_buf_clear_namespace(buf, ns, lineindex,
                                             displayer.get_next_line())
            lines = create_lines()
            vim.api.nvim_buf_set_lines(buf, lineindex,
                                       displayer.get_next_line(), false, lines)

            vim.api.nvim_buf_add_highlight(buf, ns, 'Title', lineindex, 0,
                                           name:len())
        end
        if url:len() > urlwidth then
            urlwidth = url:len()
            for _, x in ipairs(displayers) do x.padurl() end
            redraw_all = true
            local len = emptypadding:len()
            while len < urlwidth + separator_length do
                emptypadding = emptypadding .. ' '
                len = len + 1
            end
        else
            displayer.padurl()
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
            if not plugins[url] then
                plugins[url] = make_displayer(url)
            end
            return plugins[url]
        end
    }
end
return display
