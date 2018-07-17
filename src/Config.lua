local Types = (require 'Utility').entityTypes

local CONFIG = {
    gameScale = 2,  -- 1 or 2
    base = {
        basicAttributes = {
            type = Types.base,
            health = 100,
            defense = 0.8, -- Avoids 80% of damage
            repair = 0.5,  -- health regen per second
        },
    },
    basicFactory = {
        basicAttributes = {
            type = Types.factory,
            health = 50,
            defense = 0.1,
            repair = 1
        },
        spawnRate = 10,
    },
    basicTower = {
        basicAttributes = {
            type = Types.tower,
            health = 100,
            defense = 0.3,
            repair = 0.2
        },
    },
    basicShip = {
        basicAttributes = {
            type = Types.ship,
            health = 25,
            defense = 0,
        },
    },
}

return CONFIG
