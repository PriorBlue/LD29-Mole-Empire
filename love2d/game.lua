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
	o.sound = {}

	o.init = function()
		o.menu = love.game.newMainMenu(o)
		o.world = love.game.newWorld(o)
		o.credits = love.game.newCredits(o)

		o.menu.init()
		o.world.init()
		o.credits.init()

		o.sound[1] = love.audio.newSource("sfx/menu.ogg", "static")
		o.sound[1]:setLooping(true)
		o.sound[2] = love.audio.newSource("sfx/ambient.ogg", "static")
		o.sound[2]:setLooping(true)
		o.sound[1]:play()
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
		o.sound[1]:stop()
		o.sound[2]:stop()
		if o.state == STATE_MAIN_MENU then
			o.sound[1]:play()
		elseif o.state == STATE_GAME then
			o.sound[2]:play()
		end
	end

	o.setVersion = function(version)
		o.version = version
	end

	o.onKeyHit = function(key, code)
		if o.state == STATE_GAME then
			if key == "i" then
				o.world.save("map")
			elseif key == "l" then
				o.world.load("map")
			end
		end
	end

	o.onMouseHit = function(x, y, key)
		if o.state == STATE_GAME then
			if key == "wd" then
				o.world.tileID = o.world.tileID + 1
			elseif key == "wu" then
				o.world.tileID = o.world.tileID - 1
			elseif key == "l" then
				o.world.drawTile = true
			end
		end
	end

	o.onMouseUp = function(x, y, key)
		if o.state == STATE_GAME then
			if key == "l" then
				o.world.drawTile = false
			end
		end
	end

	return o
end
