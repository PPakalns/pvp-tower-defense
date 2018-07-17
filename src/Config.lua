local Types = (require 'Utility').entityTypes

local CONFIG = {
    base = {
        basicAttributes = {
            type = Types.base,
            health = 100,
            defense = 0.8, -- Avoids 80% of damage
            repair = 0.5,
        },
    },
    basicFactory = {
        basicAttributes = {
            type = Types.factory,
            health = 50,
            defense = 1,
            repair = 1
        },
    },
    basicTower = {
        basicAttributes = {
            type = Types.tower,
            health = 100,
            defense = 0.7,
            repair = 0.2
        },
    },
    basicShip = {
        basicAttributes = {
            type = Types.ship,
            health = 25,
            defense = 1,
        },
    },
}

return CONFIG
