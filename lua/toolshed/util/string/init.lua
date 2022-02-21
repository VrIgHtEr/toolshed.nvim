local string = setmetatable({}, { __index = string })

--- Iterate over characters of a string
---@param self string
---@return function Iterator
function string:chars()
    local i, max = 0, #self
    return function()
        if i < max then
            i = i + 1
            return self:sub(i, i)
        end
    end
end

---Iterate over bytes of a string
---@param self string
---@return function Iterator
function string:bytes()
    local i, max = 0, #self
    return function()
        if i < max then
            i = i + 1
            return self:byte(i)
        end
    end
end

---Iterate over UTF8 codepoints in a string
---@param self string
---@return function Iterator
function string:codepoints()
    local nxt, cache = string.bytes(self)
    return function()
        local c = cache or nxt()
        cache = nil
        if c == nil then
            return
        end
        if c <= 127 then
            return string.char(c)
        end
        assert(c >= 194 and c <= 244, 'invalid byte in utf-8 sequence: ' .. tostring(c))
        local ret = { c }
        c = nxt()
        assert(c, 'unexpected eof in utf-8 string')
        assert(c >= 128 and c <= 191, 'expected multibyte sequence: ' .. tostring(c))
        table.insert(ret, c)
        local count = 2
        while true do
            cache = nxt()
            if not cache or cache < 128 or cache > 191 then
                break
            end
            count = count + 1
            if count > 4 then
                error 'multibyte sequence too long in utf-8 string'
            end
            table.insert(ret, cache)
        end
        return string.char(unpack(ret))
    end
end

---Iterate over UTF8 codepoints in a string, while converting windows (\r\n) or mac (\r) newlines to linux format (\n)
---@param self string
---@return function Iterator
function string:filteredcodepoints()
    local codepoint, cache = string.codepoints(self)
    return function()
        local cp = cache or codepoint()
        cache = nil
        if cp == '\r' then
            cache = codepoint()
            if cache == '\n' then
                cache = nil
            end
            return '\n'
        elseif cp then
            return cp
        end
    end
end

---Returns an iterator that returns individual lines in a string, handling any format of newline
---@param self string
---@return function Iterator
function string:lines()
    local codepoints = string.filteredcodepoints(self)
    return function()
        local line = {}
        for c in codepoints do
            if c == '\n' then
                return table.concat(line)
            end
            table.insert(line, c)
        end
        if #line > 0 then
            return table.concat(line)
        end
    end
end

---Trims whitespace from either end of the string
---@param self string
---@return string
function string:trim()
    local from = self:match '^%s*()'
    return from > #self and '' or self:match('.*%S', from)
end

---Returns the Levenshtein distance between two strings
---@param self string
---@param B string
---@return number
function string:distance(B)
    local la, lb, x = self:len(), B:len(), {}
    if la == 0 then
        return lb
    end
    if lb == 0 then
        return la
    end
    if la < lb then
        self, la, B, lb = B, lb, self, la
    end
    for i = 1, lb do
        x[i] = i
    end
    for r = 1, la do
        local t, l, v = r - 1, r, self:sub(r, r)
        for c = 1, lb do
            if v ~= B:sub(c, c) then
                if x[c] < t then
                    t = x[c]
                end
                if l < t then
                    t = l
                end
                t = t + 1
            end
            x[c], l, t = t, t, x[c]
        end
    end
    return x[lb]
end

local base64 = require 'toolshed.util.string.base64'
function string:base64_encode()
    return base64.encode(self)
end

function string:base64_decode()
    return base64.decode(self)
end
return string
