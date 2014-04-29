function love.game.newItem(parent, type, x, y)
	local o = {}

	o.parent = parent
	o.batchID = 0
	o.imageID = 0
	o.maxHealth = 0
	o.health = 0
	o.maxAttack = 0
	o.attack = 0

	o.strength = 0
	o.luck = 0
	o.speed = 0

	o.type = type or 1
	o.x = x or 0
	o.y = y or 0

	o.init = function()

	end

	o.update = function(dt)

	end

	return o
end