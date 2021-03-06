function love.game.newEnemy(parent, type, x, y)
	local o = {}

	o.parent = parent
	o.direction = 0
	o.directionAnimation = 1
	o.directionAttack = 0
	o.maxHealth = hp or 25
	o.health = o.maxHealth
	o.maxAttack = 100
	o.attack = 100
	o.death = false
	o.attacked = 0
	o.moving = false
	o.target = nil

	o.strength = strength or 1
	o.luck = luck or 0
	o.speed = speed or 25
	o.drop = drop or 0

	o.type = type or 1
	o.x = x or 0
	o.y = y or 0
	o.x2 = o.x
	o.y2 = o.y

	o.init = function()

	end

	o.update = function(dt)
		if o.attack < 100 then
			o.attack = o.attack + dt * 250
		elseif love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
			--o.attack = 0
			--o.directionAttack = o.direction
			--o.soundAttack[math.random(1, 4)]:play()
		end

		if not o.death then
			o.moving = false

			if o.target then
				if math.length(o.x, o.y, o.target.x, o.target.y) > 16 then
					o.x2 = o.target.x
					o.y2 = o.target.y
				else
					o.x2 = o.x
					o.y2 = o.y
				end
			end

			local tx = o.x / 16 + 1
			local ty = o.y / 16 + 1

			if math.abs(o.y - o.y2) > 1 then
				if o.y > o.y2 and o.parent.parent.map.isCollision(tx, ty - 0.5) == false then
					o.y = o.y - dt * o.speed
					o.directionAnimation = 0
					o.moving = true
					o.direction = math.pi
				elseif o.y < o.y2 and o.parent.parent.map.isCollision(tx, ty + 0.5) == false then
					o.y = o.y + dt * o.speed
					o.directionAnimation = 1
					o.moving = true
					o.direction = math.pi * 2
				else
					o.y2 = o.y
				end
			else
				o.y2 = o.y
			end

			if math.abs(o.x - o.x2) > 1 then
				if o.x > o.x2 and o.parent.parent.map.isCollision(tx - 0.25, ty) == false then
					o.x = o.x - dt * o.speed
					o.directionAnimation = 2
					o.moving = true
					o.direction = math.pi * 1.5
				elseif o.x < o.x2 and o.parent.parent.map.isCollision(tx + 0.25, ty) == false then
					o.x = o.x + dt * o.speed
					o.directionAnimation = 3
					o.moving = true
					o.direction = math.pi * 0.5
				else
					o.x2 = o.x
				end
			else
				o.x2 = o.x
			end
		end

		if o.attacked > 0 then
			o.attacked = o.attacked - dt
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")
		if o.death then
			o.parent.quad:setViewport(0, 96, 16, 24)
		elseif o.moving or o.attack < 100 then
			o.parent.quad:setViewport(math.floor((T.getTime() * 10) % 4) * 16, o.directionAnimation * 24, 16, 24)
		else
			o.parent.quad:setViewport(0, o.directionAnimation * 24, 16, 24)
		end
		if o.attack < 100 then
			o.parent.quadAttack[o.type]:setViewport(math.floor(o.attack / 25) * 16, 0, 16, 16)
			G.draw(o.parent.imgAttack[o.type], o.parent.quadAttack, (o.x - 16 * 0.5) * sw + x + math.sin(o.directionAttack) * 16 * sw, (o.y - 24 * 0.5) * sh + y + math.cos(o.directionAttack) * 16 * sh, 0, sw, sh)
		end

		G.setColor(255, math.min(1 - o.attacked / 0.2, 1) * 255, math.min(1 - o.attacked / 0.2, 1) * 255)
		G.draw(o.parent.imgEnemies[o.type], o.parent.quad, (o.x - 16 * 0.5) * sw + x, (o.y - 32 * 0.5) * sh + y, 0, sw, sh)

		if not o.death and o.health < o.maxHealth then
			-- Healthbar
			G.setLineWidth(sw)
			G.setColor(0, 0, 0, 127)
			G.rectangle("fill", (o.x - 16 * 0.5 - 2) * sw + x, (o.y - 48 * 0.5 - 2) * sh + y, (16 + 4) * sw, (2 + 4) * sh)
			G.setColor(255, 0, 0, 127)
			G.rectangle("line", (o.x - 16 * 0.5 - 1) * sw + x, (o.y - 48 * 0.5 - 1) * sh + y, (16 + 2) * sw, (2 + 2) * sh)
			G.setColor((1 - o.health / o.maxHealth) * 255, (o.health / o.maxHealth) * 255, 0)
			G.rectangle("fill", (o.x - 16 * 0.5) * sw + x, (o.y - 48 * 0.5) * sh + y, (o.health / o.maxHealth) * 16 * sw, 2 * sw)

			if sw > 1.0 then
				-- Healthpoints
				if sw == 2.0 then
					G.setFont(FONT_SMALL)
				else
					G.setFont(FONT_NORMAL)
				end
				G.setColor(255, 255, 255)
				G.printf(o.health .. "/" .. o.maxHealth, (o.x - 64 * 0.5) * sw + x, (o.y - 72 * 0.5) * sh + y, 64 * sw, "center")
			end
		end
	end

	o.moveTo = function(x, y)
		if o.parent.parent.map.isCollision(x / 16, y / 16) == false then
			o.x2 = x
			o.y2 = y
		end
	end

	return o
end