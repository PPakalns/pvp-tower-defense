local Types = (require 'Utility').entityTypes

local CONFIG = {
    gameScale = 2,  -- 1 or 2
    base = {
        basicAttributes = {
            type = Types.base,
            health = 100,  -- HP
            defense = 0.8, -- Avoids 80% of damage
            repair = 0.5,  -- health regen per second
        },
        basicAttack = {
            radius = 32 * 4,   -- Reach (in reality rectangle in size (2*radius)X(2*radius))
            damage = 10,       -- Damage dealt by one cannonball
            reloadSec = 0.5,   -- Seconds to reload one cannonball
        }
    },
    basicFactory = {
        basicAttributes = {
            type = Types.factory,
            health = 50,
            defense = 0.1,
            repair = 1
        },
        spawnSec = 10,
    },
    basicTower = {
        basicAttributes = {
            type = Types.tower,
            health = 100,
            defense = 0.5,
            repair = 0.2
        },
        basicAttack = {
            radius = 32 * 3,
            damage = 20,
            reloadSec = 1,
        }
    },
    basicShip = {
        basicAttributes = {
            type = Types.ship,
            health = 25,
            defense = 0,
            repair = 0,
        },
        basicAttack = {
            radius = 32 * 2,
            damage = 10,
            reloadSec = 1,
        }
    },
}

return CONFIG
