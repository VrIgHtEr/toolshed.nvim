local M = {}
local MT = {}

function MT:size()
    if self.parity then
        return self.capacity - (self.tail - self.head)
    else
        return self.head - self.tail
    end
end

local function grow(self)
    local newbuf = {}
    for x in self:iterator() do
        table.insert(newbuf, x)
    end
    self.head = self:size()
    self.buf = newbuf
    self.capacity = self.capacity * 2
    self.parity = false
    self.tail = 0
end

function MT:enqueue(item)
    if self.parity and self.head == self.tail then
        grow(self)
    end
    self.head = self.head + 1
    self.buf[self.head] = item
    if self.head == self.capacity then
        self.parity = not self.parity
        self.head = 0
    end
    self.version = self.version + 1
end

function MT:prequeue(item)
    if self.parity and self.head == self.tail then
        grow(self)
    end
    if self.tail == 0 then
        self.tail = self.capacity
        self.parity = not self.parity
    end
    self.buf[self.tail] = item
    self.tail = self.tail - 1
    self.version = self.version + 1
end

function MT:dequeue()
    if self.parity or self.head ~= self.tail then
        self.tail = self.tail + 1
        local ret = self.buf[self.tail]
        self.buf[self.tail] = nil
        if self.tail == self.capacity then
            self.parity = not self.parity
            self.tail = 0
        end
        self.version = self.version + 1
        return ret
    end
end

function MT:iterator()
    local head = self.head
    local parity = self.parity
    local version = self.version

    return function()
        if version ~= self.version then
            error 'collection modified while being iterated'
        end
        if head == self.tail and not parity then
            return nil
        end
        head = head + 1
        local ret = self.buf[head]
        if head == self.capacity then
            parity = not parity
            head = 0
        end
        return ret
    end
end

function M.new()
    return setmetatable({
        parity = false,
        head = 0,
        tail = 0,
        capacity = 1,
        version = 0,
        buf = {},
    }, MT)
end
function MT.__index(_, k)
    return MT[k]
end
function MT.__metatable() end
return M
