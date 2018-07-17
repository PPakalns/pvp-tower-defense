local Utility = {}

Utility.createArray2D = function(yDim, xDim, defaultVal)
    local arr = {}
    for y = 1, yDim do
        local tmpArr = {}
        if defaultVal ~= nil then
            for x = 1, xDim do
                tmpArr[x] = defaultVal
            end
        end
        arr[y] = tmpArr
    end
    return arr
end

Utility.entityTypes = {
    none = 0,
    base = 1,
    factory = 2,
    tower = 3,
    ship = 4,
}

return Utility
