function love.game.newPlayer(parent, x, y)
	local o = {}

	o.parent = parent
	o.img = G.newImage("gfx/player.png")
	o.img:setFilter("nearest", "nearest")
	o.quad = G.newQuad(0, 24, 16, 24, 64, 96)
	o.imgAttack = G.newImage("gfx/attack.png")
	o.quadAttack = G.newQuad(0, 0, 16, 16, 64, 16)
	o.soundAttack = {}
	o.soundAttack[1] = love.audio.newSource("sfx/attack1.wav", "static")
	o.soundAttack[2] = love.audio.newSource("sfx/attack2.wav", "static")
	o.soundAttack[3] = love.audio.newSource("sfx/attack3.wav", "static")
	o.soundAttack[4] = love.audio.newSource("sfx/attack4.wav", "static")
	o.direction = 0
	o.directionAnimation = 0
	o.directionAttack = 0
	o.maxHealth = 25
	o.health = 25
	o.maxAttack = 100
	o.attack = 100
	o.moving = false
	o.attacked = 0

	o.strength = 3
	o.luck = 2
	o.speed = 50

	o.x = x or 0
	o.y = y or 0

	o.init = function()
		o.direction = math.pi * 2
		o.directionAnimation = 1
		o.directionAttack = 0
		o.maxHealth = 25
		o.health = 25
		o.x = 128
		o.y = 128
		o.maxAttack = 100
		o.attack = 100
		o.moving = false
		o.attacked = 0

		o.strength = 3
		o.luck = 2
		o.speed = 50
	end

	o.update = function(dt)
		if o.health > 0 then
			-- Regeneration
			if o.health < o.maxHealth then
				o.health = o.health + dt * (o.maxHealth / 100)
			end

			-- Attack
			if o.attack < 100 then
				o.attack = o.attack + dt * 250
			elseif love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
				o.attack = 0
				o.directionAttack = o.direction
				o.soundAttack[math.random(1, 4)]:play()
				o.parent.enemyManager.attackEnemy(o.x + math.sin(o.directionAttack) * 12, (o.y - 4) + math.cos(o.directionAttack) * 16, o.strength + math.random(0, o.luck))
			end

			o.moving = false
			
			local tx = o.x / 16
			local ty = o.y / 16

			if love.keyboard.isDown("w") and o.parent.layer[2].getTile(tx, ty - 0.5) == 0 then
				o.y = o.y - dt * o.speed
				o.directionAnimation = 0
				o.moving = true
				o.direction = math.pi
			elseif love.keyboard.isDown("s") and o.parent.layer[2].getTile(tx, ty + 0.5) == 0 then
				o.y = o.y + dt * o.speed
				o.directionAnimation = 1
				o.moving = true
				o.direction = math.pi * 2
			end

			if love.keyboard.isDown("a") and o.parent.layer[2].getTile(tx - 0.25, ty) == 0 then
				o.x = o.x - dt * o.speed
				o.directionAnimation = 2
				o.moving = true
				o.direction = math.pi * 1.5
			elseif love.keyboard.isDown("d") and o.parent.layer[2].getTile(tx + 0.25, ty) == 0 then
				o.x = o.x + dt * o.speed
				o.directionAnimation = 3
				o.moving = true
				o.direction = math.pi * 0.5
			end

			if o.attacked > 0 then
				o.attacked = o.attacked - dt
			end
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")
		if o.health > 0 and (o.moving or o.attack < 100) then
			o.quad:setViewport(math.floor((T.getTime() * 10) % 4) * 16, o.directionAnimation * 24, 16, 24)
		else
			o.quad:setViewport(16, o.directionAnimation * 24, 16, 24)
		end

		G.setColor(255, math.min(1 - o.attacked / 1.0, 1) * 255, math.min(1 - o.attacked / 1.0, 1) * 255)
		G.draw(o.img, o.quad, (o.x - 16 * 0.5) * sw + x, (o.y - 32 * 0.5) * sh + y, 0, sw, sh)
	end

	o.drawAttack = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")
		if o.attack < 100 then
			o.quadAttack:setViewport(math.floor(o.attack / 25) * 16, 0, 16, 16)
			G.draw(o.imgAttack, o.quadAttack, o.x * sw + x + math.sin(o.directionAttack) * 12 * sw - 8 * sw, (o.y - 4) * sh + y + math.cos(o.directionAttack) * 16 * sh - 8 * sh, 0, sw, sh)
		end
	end

	o.addHealth = function(health)
		o.health = o.health + health

		if o.health < 0 then
			o.health = 0
		elseif o.health > o.maxHealth then
			o.health = o.maxHealth
		end
	end

	return o
end