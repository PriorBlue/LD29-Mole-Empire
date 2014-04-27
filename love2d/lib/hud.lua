function love.game.newHud(parent, x, y)
	local o = {}

	o.parent = parent

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
		local ready = math.min(o.parent.timer * 0.5, 1)

		G.setLineWidth(2)
		G.setBlendMode("alpha")
		-- Health bar
		G.setColor(255, 0, 0, 255 * ready)
		G.rectangle("fill", 8, 8, o.health / o.maxHealth * o.maxHealth * ready, 12)
		G.setColor(255, 255, 255, 127 * ready)
		G.rectangle("line", 8 - 4, 8 - 4, o.maxHealth + 8, 12 + 8)
		G.setFont(FONT_SMALL)
		if o.maxHealth < 100 then
			G.print("HP " .. math.floor(o.health) .. " / " .. math.floor(o.maxHealth), o.maxHealth + 24, 6)
		else
			G.printf("HP " .. math.floor(o.health) .. " / " .. math.floor(o.maxHealth), 6, 6, o.maxHealth, "center")
		end
		-- Attack bar
		G.setColor(255, 191, 0, 255 * ready)
		G.rectangle("fill", 8, 34, o.attack / o.maxAttack * o.maxAttack * ready, 12)
		G.setColor(255, 255, 255, 127 * ready)
		G.rectangle("line", 8 - 4, 34 - 4, o.maxAttack + 8, 12 + 8)
		-- Stats
		G.setColor(255, 255, 255, 127 * ready)
		G.print("Str " .. o.parent.player.strength, W.getWidth() - 64, W.getHeight() - 64)
		G.print("Spd " .. o.parent.player.speed, W.getWidth() - 64, W.getHeight() - 44)
		G.print("Luk " .. o.parent.player.luck, W.getWidth() - 64, W.getHeight() - 24)
	end

	return o
end