function love.game.newItem(parent, type, x, y)
	local o = {}

	o.parent = parent
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

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")
		o.parent.quadItems:setViewport(o.imageID * 8, 0, 8, 8)

		G.draw(o.parent.imgItems, o.parent.quadItems, (o.x - 4) * sw + x, (o.y - 4) * sh + y, 0, sw, sh)
	end

	return o
end