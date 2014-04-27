function love.game.newHud(parent, x, y)
	local o = {}

	o.x = x or 0
	o.y = y or 0
	o.maxHealth = 25
	o.health = 25
	o.maxAttack = 100
	o.attack = 100

	o.init = function()

	end

	o.update = function(dt)

	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setLineWidth(2)
		G.setBlendMode("alpha")
		-- Health bar
		G.setColor(255, 0, 0)
		G.rectangle("fill", 8, 8, o.health / o.maxHealth * o.maxHealth, 12)
		G.setColor(255, 255, 255)
		G.rectangle("line", 8, 8, o.maxHealth, 12)
		-- Attack bar
		G.setColor(255, 191, 0)
		G.rectangle("fill", 8, 24, o.attack / o.maxAttack * o.maxAttack, 12)
		G.setColor(255, 255, 255)
		G.rectangle("line", 8, 24, o.maxAttack, 12)
	end

	return o
end