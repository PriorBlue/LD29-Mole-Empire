function love.game.newMainMenu(parent)
	local o = {}

	o.parent = parent
	o.hover = nil
	o.buttons = nil
	o.quadBackground = G.newQuad(0, 0, W.getWidth(), W.getHeight(), 32, 32)
	o.imgBackground = G.newImage("gfx/bg.png")
	o.quadBorder = G.newQuad(0, 0, 128, W.getHeight(), 128, 32)
	o.imgBorder = G.newImage("gfx/border.png")
	o.imgBorder:setWrap("repeat", "repeat")
	o.imgBackground:setWrap("repeat", "repeat")
	o.imgButton = G.newImage("gfx/button.png")
	o.imgButton:setWrap("repeat", "repeat")

	o.init = function()
		o.buttons = {
			"Start Game",
			"Editor",
			"Credits",
			"Exit Game",
		}
	end

	o.update = function(dt)
		if love.mouse.isDown("l") then
			for i = 1, #o.buttons do
				local x = W.getWidth() * 0.5 - 160
				local y = W.getHeight() * 0.7 / #o.buttons * (i - 1) + W.getHeight() / #o.buttons

				if o.isBoxCollide(love.mouse.getX(), love.mouse.getY(), x, y, 320, 96) then
					if i == 1 then
						o.parent.setState(STATE_GAME)
					elseif i == 2 then
						o.parent.setState(STATE_EDITOR)
					elseif i == 3 then
						o.parent.setState(STATE_CREDITS)
					elseif i == 4 then
						love.event.quit()
					end
				end
			end
		end
	end

	o.draw = function()
		G.setColor(255, 255, 255)
		o.quadBackground:setViewport(0, -T.getTime() * 15, W.getWidth(), W.getHeight())
		G.draw(o.imgBackground, o.quadBackground, x, y)

		o.quadBorder:setViewport(0, -T.getTime() * 20, 128, W.getHeight())
		G.draw(o.imgBorder, o.quadBorder, -32, 0)
		G.draw(o.imgBorder, o.quadBorder, W.getWidth() - 96, 0)

		G.setFont(FONT_TITLE)
		G.setColor(255, 255, 255, 191)
		G.printf("Mole", -30, 10, W.getWidth(), "center")
		G.setColor(191, 0, 0)
		G.printf("Mole", -32, 8, W.getWidth(), "center")

		G.setFont(FONT_TITLE2)
		G.setColor(255, 255, 255, 191)
		G.printf("Empire", 4, 20, W.getWidth(), "center")
		G.setColor(31, 31, 31)
		G.printf("Empire", 0, 16, W.getWidth(), "center")
		
		G.setFont(FONT_BIG)
		G.setColor(255, 255, 255)
		for i = 1, #o.buttons do
			local x = W.getWidth() * 0.5 - 160
			local y = W.getHeight() * 0.7 / #o.buttons * (i - 1) + W.getHeight() / #o.buttons

			if o.isBoxCollide(love.mouse.getX(), love.mouse.getY(), x, y, 320, 96) then
				G.setColor(127, 191, 255)
				G.draw(o.imgButton, x, y)
				G.setColor(0, 0, 0, 127)
				G.printf(o.buttons[i], x + 2, y + 34, 320, "center")
				G.setColor(255, 255, 127)
				G.printf(o.buttons[i], x, y + 32, 320, "center")
			else
				G.setColor(255, 255, 255)
				G.draw(o.imgButton, x, y)
				G.setColor(0, 0, 0, 127)
				G.printf(o.buttons[i], x + 2, y + 34, 320, "center")
				G.setColor(255, 255, 255)
				G.printf(o.buttons[i], x, y + 32, 320, "center")
			end
		end

		G.setFont(FONT_SMALL)
		G.setColor(255, 255, 255)
		G.print(parent.version, W.getWidth() - 40, W.getHeight() - 24)
	end

	o.isBoxCollide = function(x, y, box_x, box_y, box_width, box_height)
		if x >= box_x and y >= box_y and x <= box_x + box_width and y <= box_y + box_height then
			return true
		end
	end

	return o
end