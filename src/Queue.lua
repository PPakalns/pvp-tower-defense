local class = require "middleclass"

local Queue = class('Queue')

function Queue:initialize()
    self.first = 1
    self.last = 1
    self.arr = {}
end

function Queue:pop()
    if self.first == self.last then
        return nil
    end
    local elem = self.arr[self.first]
    self.first = self.first + 1
    return elem
end

function Queue:push(elem)
    self.arr[self.last] = elem
    self.last = self.last + 1
end

function Queue:isEmpty()
    return self.first == self.last
end

return Queue
