function love.game.newCredits(parent)
	local o = {}

	o.parent = parent

	o.init = function()

	end

	o.update = function(dt)
		if love.keyboard.isDown("escape") then
			o.parent.setState(STATE_MAIN_MENU)
		end
	end

	o.draw = function()
		G.setFont(FONT_NORMAL)
		G.setColor(255, 255, 255)
		G.printf(
			"[Code, Graphics, Sound]\nMarcus Ihde (PriorBlue)\n\n" ..
			"[Engine]\nLove2d (Lua Script)\n(love2d.org)\n\n" ..
			"[External Libs]\nLight vs. Shadow Engine (by PriorBlue)\n(love2d.org/forums/viewtopic.php?f=5&t=77418)\n\n" ..
			"[Used Tools]\nPaint.NET (Graphics)\nAseprite (Animation)\nmusagi (Music)\nsfxr (Sound)\n\n" ..
			"[License]\nMIT",
			W.getWidth() * 0.5 - 256, W.getHeight() * 0.5 - 192, 512, "center"
		)
	end

	return o
end