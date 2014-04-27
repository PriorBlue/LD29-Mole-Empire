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
			"[Used Tools]\nPaint.NET (Graphics)\nmusagi, cgMusic (Music)\nsfxr (Sound)\n\n" ..
			"[Foreign Resources]\nAlagard.ttf (Font)\nTSerial.lua (load/save tables)\n\n" ..
			"[Source]\ngithub.com/PriorBlue/LD29-Mole-Empire\n\n" ..
			"[License]\nMIT",
			W.getWidth() * 0.5 - 256, 48, 512, "center"
		)
	end

	return o
end