local Utility = {}

Utility.createArray2D = function(yDim, xDim, defaultVal)
    local arr = {}
    for y = 1, yDim do
        local tmpArr = {}
        for x = 1, xDim do
            tmpArr[x] = defaultVal
        end
        arr[y] = tmpArr
    end
    return arr
end

return Utility
