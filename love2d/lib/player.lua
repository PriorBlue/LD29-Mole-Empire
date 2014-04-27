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
	o.x = x or 0
	o.y = y or 0
	--o.walking = false

	o.init = function()

	end

	o.update = function(dt)
		if o.attack < 100 then
			o.attack = o.attack + dt * 250
		elseif love.keyboard.isDown(" ") or love.keyboard.isDown("return") then
			o.attack = 0
			o.directionAttack = o.direction
			o.soundAttack[math.random(1, 4)]:play()
		end

		o.moving = false

		if love.keyboard.isDown("w") then
			o.y = o.y - dt * 50
			o.directionAnimation = 0
			o.moving = true
			o.direction = math.pi
		elseif love.keyboard.isDown("s") then
			o.y = o.y + dt * 50
			o.directionAnimation = 1
			o.moving = true
			o.direction = math.pi * 2
		end

		if love.keyboard.isDown("a") then
			o.x = o.x - dt * 50
			o.directionAnimation = 2
			o.moving = true
			o.direction = math.pi * 1.5
		elseif love.keyboard.isDown("d") then
			o.x = o.x + dt * 50
			o.directionAnimation = 3
			o.moving = true
			o.direction = math.pi * 0.5
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		G.setBlendMode("alpha")
		if o.moving or o.attack < 100 then
			o.quad:setViewport(math.floor((T.getTime() * 10) % 4) * 16, o.directionAnimation * 24, 16, 24)
		end
		if o.attack < 100 then
			o.quadAttack:setViewport(math.floor(o.attack / 25) * 16, 0, 16, 16)
			G.draw(o.imgAttack, o.quadAttack, (o.x - 16 * 0.5) * sw + x + math.sin(o.directionAttack) * 16 * sw, (o.y - 8 * 0.5) * sh + y + math.cos(o.directionAttack) * 16 * sh, 0, sw, sh)
		end

		G.draw(o.img, o.quad, (o.x - 16 * 0.5) * sw + x, (o.y - 24 * 0.5) * sh + y, 0, sw, sh)
	end

	return o
end