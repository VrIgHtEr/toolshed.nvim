local display = {}
function display.new()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    local maxline = 0
    local plugins = {}

    local function make_display_string(url, str)
        if url == nil or type(url) ~= "string" then url = "" end
        if str == nil or type(str) ~= "string" then str = "" end
        local maxlen = 35
        if url:len() > maxlen then url = url:sub(1, maxlen) end
        while url:len() < maxlen do url = url .. ' ' end
        return url .. ': ' .. str
    end

    local function make_displayer(url)
        local line = maxline
        maxline = maxline + 1
        return function(str)
            vim.schedule(function()
                str = make_display_string(url, str)
                vim.api.nvim_buf_set_lines(buf, line, line + 1, false, {str})
            end)
        end
    end

    return {
        close = function()
            vim.schedule(function()
                vim.api.nvim_buf_delete(buf, {force = true})
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
