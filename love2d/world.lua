--require "lib/map"

function love.game.newWorld(parent)
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

	end

	return o
end