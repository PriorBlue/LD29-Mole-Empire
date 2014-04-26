love.game = {}

require "main_menu"
require "world"
require "credits"

STATE_MAIN_MENU = 1
STATE_GAME = 2
STATE_CREDITS = 3

function love.game.newGame()
	local o = {}

	o.state = STATE_MAIN_MENU
	o.version = "0.0.0"
	o.menu = nil
	o.world = nil
	o.credits = nil

	o.init = function()
		o.menu = love.game.newMainMenu(o)
		o.world = love.game.newWorld(o)
		o.credits = love.game.newCredits(o)

		o.menu.init()
		o.world.init()
		o.credits.init()
	end

	o.update = function(dt)
		if o.state == STATE_MAIN_MENU then
			o.menu.update(dt)
		elseif o.state == STATE_GAME then
			o.world.update(dt)
		elseif o.state == STATE_CREDITS then
			o.credits.update(dt)
		end
	end

	o.draw = function()
		if o.state == STATE_MAIN_MENU then
			o.menu.draw()
		elseif o.state == STATE_GAME then
			o.world.draw()
		elseif o.state == STATE_CREDITS then
			o.credits.draw()
		end
	end

	o.setState = function(state)
		o.state = state
	end

	o.setVersion = function(version)
		o.version = version
	end

	return o
end
