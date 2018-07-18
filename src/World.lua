local class = require "middleclass"

local Vec2 = require "Vec2"
local Utility = require "Utility"
local Entity = require 'Entity'
local Bump = require 'bump'
local Queue = require 'Queue'
local Types = (require 'Utility').entityTypes
local Entities = require 'Entities'
local Config = require 'Config'

local World = class('World')

function World:initialize(tileCntX, tileCntY)
    self.width = tileCntX
    self.height = tileCntY
    self.offX = 16
    self.offY = 16
    self.tileSize = 32

    -- bump library collision world
    self.cworld = Bump.newWorld()

    local middleRow = math.floor(self.height / 2) + 1
    self.baseCoords = { Vec2:new(1, middleRow), Vec2:new(self.width, middleRow) }
    self.factoryCnt = {0, 0}
    self.shipCnt = {0, 0}
    self.mapShipCnt = {}
    self.mapDistance = {}
    for i = 1, 2 do
        self.mapShipCnt[i] = Utility.createArray2D(self.height, self.width, 0)

        -- Stores distance to enemy base
        self.mapDistance[i] = Utility.createArray2D(self.height, self.width, nil)
    end
    self.map = Utility.createArray2D(self.height, self.width, nil)
end

function World:initializeEntities(gameContext)
    for y = 1, self.height do
        for x = 1, self.width do
            gameContext.entityManager:addEntity(Entities.createWaterEntity(gameContext, self:getWorldCoord(Vec2:new(x, y))))
        end
    end

    for i = 1, #self.baseCoords do
        gameContext.entityManager:addEntity(Entities.createBaseEntity(gameContext, i, self.baseCoords[i]))
    end

    local d = math.floor(self.width / 2) - 2
    -- Temporary buildings to demonstrate pathfinding
    for i = 1, Config.gameScale * 3 do
        gameContext.entityManager:addEntity(Entities.createBasicTower(gameContext, 1, Vec2:new(math.random(2, 2 + d), math.random(1, self.height))))
        gameContext.entityManager:addEntity(Entities.createBasicTower(gameContext, 2, Vec2:new(self.width - math.random(1, 1 + d), math.random(1, self.height))))
        gameContext.entityManager:addEntity(Entities.createBasicFactory(gameContext, 1, Vec2:new(math.random(2, 2 + d), math.random(1, self.height))))
        gameContext.entityManager:addEntity(Entities.createBasicFactory(gameContext, 2, Vec2:new(self.width - math.random(1, 1 + d), math.random(1, self.height))))
    end

    -- We do not initialize pathfinding, because it is already done when bases and other buildings are added
end

function World:getShortestPath(map, factoryCnt, startPos, enemyTeam)

    -- Simple bfs to get shortest paths

    -- All ships and ship facilities must reach their target
    local enemyBaseReached = false
    local enemyShips = 0
    local enemyFactories = 0

    local dist = Utility.createArray2D(self.height, self.width, nil)

    local q = Queue:new()
    q:push(startPos)
    dist[startPos.y][startPos.x] = 0

    local dirs = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}}

    while not q:isEmpty() do
        local elem = q:pop()
        local d = dist[elem.y][elem.x]
        local m = map[elem.y][elem.x]

        local lookDeeper = false

        if m == nil then
            lookDeeper = true
        elseif m.type == Types.base then
            if m.team == enemyTeam then
                enemyBaseReached = true
            else
                lookDeeper = true
            end
        elseif m.type == Types.factory then
            if m.team == enemyTeam then
                enemyFactories = enemyFactories + 1
            end
        elseif m.type == Types.tower then
        else
            error("NOT SUPPORTED")
        end

        enemyShips = enemyShips + self.mapShipCnt[enemyTeam][elem.y][elem.x]

        if lookDeeper then
            for i = 1, #dirs do
                local ty = dirs[i][1] + elem.y
                local tx = dirs[i][2] + elem.x
                if ty > 0 and tx > 0 and ty <= self.height and tx <= self.width and dist[ty][tx] == nil then
                    q:push(Vec2:new(tx, ty))
                    dist[ty][tx] = d + 1
                end
            end
        end
    end

    local ok = enemyBaseReached
        and enemyShips == self.shipCnt[enemyTeam]
        and enemyFactories == factoryCnt[enemyTeam]

    return ok, dist
end

function World:calculateDistances(map, factoryCnt)
    local calcMapDistance = {}
    local allOk = true
    for i = 1, 2 do
        local ok, calcMap = self:getShortestPath(map, factoryCnt, self.baseCoords[3 - i], i)
        allOk = ok and allOk
        calcMapDistance[i] = calcMap
    end
    return allOk, calcMapDistance
end

function World:addBuilding(basicAttributesComp, tilePos)
    print("Adding building with type "..basicAttributesComp.type.." at "..tilePos.x..", "..tilePos.y)
    if basicAttributesComp.type == Types.factory then
        self.factoryCnt[basicAttributesComp.team] = self.factoryCnt[basicAttributesComp.team] + 1
    end

    -- Assumes that path checking is already done
    self.map[tilePos.y][tilePos.x] = {team = basicAttributesComp.team, type = basicAttributesComp.type }

    local ok, calcMapDistance = self:calculateDistances(self.map, self.factoryCnt)
    if ok == false and basicAttributesComp.type ~= Types.base then
        error("Incorrectly added building to map!!!!")
    end
    self.mapDistance = calcMapDistance
end

function World:removeBuilding(basicAttributesComp, tilePos)
    if basicAttributesComp.type == Types.factory then
        self.factoryCnt[basicAttributesComp.team] = self.factoryCnt[basicAttributesComp.team] - 1
    end

    self.map[tilePos.y][tilePos.x] = nil

    local ok, calcMapDistance = self:calculateDistances(self.map, self.factoryCnt)
    if ok == false then
        if basicAttributesComp.type == Types.base then
            -- TODO, this is bad way how to detect this!!!
            error("Team "..basicAttributesComp.team.." wins!")
        end
        error("Incorrectly removed building to map!!!! How???")
    end
    self.mapDistance = calcMapDistance
end

function World:addShip(basicAttributesComp, tilePos)
    -- Update counters
    self.shipCnt[basicAttributesComp.team] = self.shipCnt[basicAttributesComp.team] + 1
    self.mapShipCnt[basicAttributesComp.team][tilePos.y][tilePos.x] =
        self.mapShipCnt[basicAttributesComp.team][tilePos.y][tilePos.x] + 1
end

function World:removeShip(basicAttributesComp, tilePos)
    -- Update counters
    self.shipCnt[basicAttributesComp.team] = self.shipCnt[basicAttributesComp.team] - 1
    self.mapShipCnt[basicAttributesComp.team][tilePos.y][tilePos.x] =
        self.mapShipCnt[basicAttributesComp.team][tilePos.y][tilePos.x] - 1
end

function World:getTileCoord(pos)
    local dx = math.max(0, math.min(self.tileSize * self.width - 1, pos.x - self.offX))
    local dy = math.max(0, math.min(self.tileSize * self.height - 1, pos.y - self.offY))
    return Vec2:new(math.floor(dx / self.tileSize) + 1, math.floor(dy / self.tileSize) + 1)
end

function World:getWorldCoord(tilePos)
    return Vec2:new(
        (tilePos.x - 1) * self.tileSize + self.offX,
        (tilePos.y - 1) * self.tileSize + self.offY
        )
end

function World:getWorldCoordMiddle(tilePos)
    local t2 = self.tileSize / 2
    return self:getWorldCoord(tilePos):selfAdd(Vec2:new(t2, t2))
end

function World:getNextTileInPath(pos, team)
    local tilePos = self:getTileCoord(pos)
    local dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

    local best = math.huge
    local nextPos = {}

    for i = 1, #dirs do
        local tx = tilePos.x + dirs[i][1]
        local ty = tilePos.y + dirs[i][2]
        if ty > 0 and ty <= self.height and self.map[ty][tx] == nil then
            local val = self.mapDistance[team][ty][tx]
            if val == nil then
                -- do nothing
            elseif val < best then
                best = val
                nextPos = Vec2:new(tx, ty)
            end
        end
    end

    if best == math.huge then
        error("Incorrect game state")
    end

    return nextPos
end


function World:getNextWorldCoordInPath(pos, team)
    return self:getWorldCoordMiddle(self:getNextTileInPath(pos, team))
end

return World
