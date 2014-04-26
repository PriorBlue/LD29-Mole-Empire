function love.game.newPlayer(parent, x, y)
	local o = {}

	o.parent = parent
	o.img = G.newImage("gfx/player.png")
	o.img:setFilter("nearest", "nearest")
	o.quad = G.newQuad(0, 0, 16, 24, 16, 96)
	o.x = x or 0
	o.y = y or 0

	o.init = function()

	end

	o.update = function(dt)
		if love.keyboard.isDown("w") then
			o.y = o.y - dt * 50
			o.quad:setViewport(0, 0, 16, 24)
		elseif love.keyboard.isDown("s") then
			o.y = o.y + dt * 50
			o.quad:setViewport(0, 24, 16, 24)
		end

		if love.keyboard.isDown("a") then
			o.x = o.x - dt * 50
			o.quad:setViewport(0, 48, 16, 24)
		elseif love.keyboard.isDown("d") then
			o.x = o.x + dt * 50
			o.quad:setViewport(0, 72, 16, 24)
		end
	end

	o.draw = function()
		G.draw(o.img, o.quad, o.x, o.y)
	end

	return o
end