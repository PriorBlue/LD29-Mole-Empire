function love.game.newHitManager(parent)
	local o = {}

	o.parent = parent
	o.hit = {}

	o.init = function()

	end

	o.update = function(dt)
		for i = 1, #o.hit do
			o.hit[i].time = o.hit[i].time - dt
			if o.hit[i].time <= 0 then
				table.remove(o.hit, i)
				break
			end
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setBlendMode("alpha")
		for i = 1, #o.hit do
			if type(o.hit[i].count) == "string" then
				G.setFont(FONT_SMALL)
			elseif type(o.hit[i].count) == "number" then
				G.setFont(FONT_NORMAL)
			end
			G.setColor(0, 0, 0)
			G.printf(o.hit[i].count, (o.hit[i].x * sw + x) - 64 + 1, (o.hit[i].y * sh + y) + 1 - (1 - o.hit[i].time) * 64, 128, "center")
			G.setColor(o.hit[i].red, o.hit[i].green, o.hit[i].blue, o.hit[i].alpha)
			G.printf(o.hit[i].count, (o.hit[i].x * sw + x) - 64, (o.hit[i].y * sh + y) - (1 - o.hit[i].time) * 64, 128, "center")
		end
	end

	o.addHit = function(x, y, count, red, green, blue, alpha)
		o.hit[#o.hit + 1] = {}
		o.hit[#o.hit].x = x
		o.hit[#o.hit].y = y
		o.hit[#o.hit].count = count or 0
		o.hit[#o.hit].red = red or 255
		o.hit[#o.hit].green = green or 255
		o.hit[#o.hit].blue = blue or 255
		o.hit[#o.hit].alpha = alpha or 255
		o.hit[#o.hit].time = 1
	end

	return o
end