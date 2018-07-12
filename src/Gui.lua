local class = require "middleclass"


-- Basic gui item : layout, button, text element, etc
local Item = class('Item')

function Item:initialize(focusable)
    self.focusable = focusable
    self.focused = false
    self.x, self.y = 0, 0
end

function Item:draw()
end

function Item:event(event)
    return true
end

function Item:update(dt)
    return true
end

function Item:focus()
    self.focused = true
end

function Item:unfocus()
    self.focused = false
end

function Item:setPosition(x, y)
    self.x, self.y = x, y
end

function Item:getHeight(x, y)
    error("abstract")
end

function Item:getHeight(x, y)
    error("abstract")
end


-- Gui text label
local Text = class('Text', Item)

function Text:initialize(text, size, textColor)
    Item.initialize(self, false)
    local font = love.graphics.newFont(size)
    love.graphics.setColor(255, 255, 255, 0)
    self.text = love.graphics.newText(font, text)
    self.color = textColor
end

function Text:getWidth()
    return self.text:getWidth()
end

function Text:getHeight()
    return self.text:getHeight()
end

function Text:draw()
    self.color:set()
    love.graphics.draw(self.text, self.x, self.y)
end


-- Simple button
local Button = class('Button', Item)

function Button:initialize(text, size, textColor, buttonColor, callback)
    Item.initialize(self, true)
    local font = love.graphics.newFont(size)
    self.text = love.graphics.newText(font, text)
    self.textColor = textColor
    self.buttonColor = buttonColor
    self.callback = callback
end

function Button:getWidth()
    return self.text:getWidth()
end

function Button:getHeight()
    return self.text:getHeight()
end

function Button:draw()
    self.buttonColor:set()
    local mode = (self.focused and "fill" or "line")
    love.graphics.rectangle(mode, self.x, self.y, self:getWidth(), self:getHeight())
    if self.focused then
        love.graphics.setColor(1, 1, 1)
    else
        self.textColor:set()
    end
    love.graphics.draw(self.text, self.x, self.y)
end

function Button:event(event)
    if event.name == 'keypressed' then
        local scancode = event.arg[2]
        if scancode == 'return' or scancode == 'kpenter' then
            if self.callback() ~= true then
                return false
            end
        end
    end
    return true
end


-- Layout class to manage list of selectable elements
local Layout = class('Layout', Item)

function Layout:initialize(previousKey, nextKey)
    Item.initialize(self, true)
    self.elements = {}
    self.focusedIdx = nil
    self.previousKey = previousKey
    self.nextKey = nextKey
end

function Layout:push(item)
    table.insert(self.elements, item)
    if self.focusedIdx == nil and item.focusable then
        self:setFocus(#self.elements)
    end
end

function Layout:setFocus(eIdx)
    if self.focusedIdx ~= nil then
        self.elements[self.focusedIdx]:unfocus()
    end
    self.focusedIdx = eIdx
    if eIdx ~= nil then
        self.elements[eIdx]:focus()
    end
end

function Layout:update(dt)
    for i = 1, #self.elements do
        self.elements[i]:update(dt)
    end
end

function Layout:event(event)
    if (self.focusedIdx ~= nil) then
        if not self.elements[self.focusedIdx]:event(event) then
            return false
        end
    end

    if event.name == "keypressed" then
        local scancode = event.arg[2]
        if scancode == self.previousKey then
            self:select(false)
            return false
        elseif scancode == self.nextKey then
            self:select(true)
            return false
        end
    end

    return true
end

-- Select next or previous element
function Layout:select(nextElement)
    if #self.elements == 0 then
        return
    end

    local direction = (nextElement and 1 or -1)
    local to, from
    if self.focusedIdx ~= nil then
        from, to = self.focusedIdx + direction, self.focusedIdx
    else
        from, to = 1, #self.elements + 1
        direction = 1
    end

    while from ~= to do
        if #self.elements < from then
            from = 1
        elseif from < 1 then
            from = #self.elements
        else
            if self.elements[from].focusable then
                self:setFocus(from)
                break
            end
            from = from + direction
        end
    end
end

-- Layout class to draw vertical list of selectable elements

local VertLayout = class('VertLayout', Layout)

function VertLayout:initialize(previousKey, nextKey, x, y, ypadding)
    Layout.initialize(self, previousKey, nextKey)
    self.ypadding = ypadding
    self:setPosition(x, y)
end

function VertLayout:draw()
    local sumy = self.y
    for i = 1, #self.elements do
        self.elements[i]:setPosition(self.x, sumy)
        self.elements[i]:draw()
        sumy = sumy + self.elements[i]:getHeight() + self.ypadding
    end
end

return {
    Item = Item,
    Text = Text,
    Button = Button,
    Layout = Layout,
    VertLayout = VertLayout,
}
