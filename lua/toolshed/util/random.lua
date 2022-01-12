local state = { 1, 0, 0, 0, 0 }
local counter = 0

return function()
    local t = state[5]

    local s = state[1]
    state[5] = state[4]
    state[4] = state[3]
    state[3] = state[2]
    state[2] = s

    t = bit.bxor(bit.rshift(t, 2))
    t = bit.band(bit.bxor(bit.lshift(t, 1)), 0xFFFFFFFF)
    t = bit.bxor(bit.bxor(s, bit.band(bit.lshift(s, 4), 0xFFFFFFFF)))
    state[1] = t
    counter = bit.band(bit.tobit(counter + 362437), 0xFFFFFFFF)
    return bit.band(bit.tobit(t + counter), 0xFFFFFFFF)
end
