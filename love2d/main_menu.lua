function love.game.newMainMenu(parent)
	local o = {}

	o.parent = parent
	o.hover = nil
	o.buttons = nil

	o.init = function()
		o.buttons = {
			"Start Game",
			"Credits",
			"Exit Game",
		}
	end

	o.update = function(dt)
		if love.mouse.isDown("l") then
			for i = 1, #o.buttons do
				local x = W.getWidth() * 0.5 - 128
				local y = W.getHeight() * 0.5 / #o.buttons * (i - 1) + W.getHeight() / #o.buttons

				if o.isBoxCollide(love.mouse.getX(), love.mouse.getY(), x, y, 256, 48) then
					if i == 1 then
						o.parent.setState(STATE_GAME)
					elseif i == 2 then
						o.parent.setState(STATE_CREDITS)
					elseif i == 3 then
						love.event.quit()
					end
				end
			end
		end
	end

	o.draw = function()
		G.setFont(FONT_BIG)
		G.setColor(127, 127, 127)
		G.printf("[LD29]Game", 0, 16, W.getWidth(), "center")

		for i = 1, #o.buttons do
			local x = W.getWidth() * 0.5 - 128
			local y = W.getHeight() * 0.5 / #o.buttons * (i - 1) + W.getHeight() / #o.buttons

			if o.isBoxCollide(love.mouse.getX(), love.mouse.getY(), x, y, 256, 48) then
				G.setColor(127, 191, 255)
			else
				G.setColor(63, 127, 255)
			end
			G.rectangle("fill", x, y, 256, 48)
			G.setColor(0, 0, 0, 127)
			G.printf(o.buttons[i], x + 2, y + 12, 256, "center")
			G.setColor(255, 255, 255)
			G.printf(o.buttons[i], x, y + 10, 256, "center")
		end

		G.setFont(FONT_SMALL)
		G.setColor(127, 127, 127)
		G.print(parent.version, W.getWidth() - 40, W.getHeight() - 16)
	end

	o.isBoxCollide = function(x, y, box_x, box_y, box_width, box_height)
		if x >= box_x and y >= box_y and x <= box_x + box_width and y <= box_y + box_height then
			return true
		end
	end

	return o
end