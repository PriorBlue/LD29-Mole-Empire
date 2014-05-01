love.game = {}

require "main_menu"
require "world"
require "credits"

STATE_MAIN_MENU = 1
STATE_GAME = 2
STATE_EDITOR = 3
STATE_CREDITS = 4

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
		o.credits.init()

		o.sound[1] = love.audio.newSource("sfx/menu.ogg")
		o.sound[1]:setLooping(true)
		o.sound[1]:setVolume(0.25)
		o.sound[1]:play()
		o.sound[2] = love.audio.newSource("sfx/ambient.ogg")
		o.sound[2]:setLooping(true)
		o.sound[2]:setVolume(0.5)
		o.sound[3] = love.audio.newSource("sfx/credits.ogg")
		o.sound[3]:setLooping(true)
		o.sound[3]:setVolume(0.25)
	end

	o.update = function(dt)
		if o.state == STATE_MAIN_MENU then
			o.menu.update(dt)
		elseif o.state == STATE_GAME or o.state == STATE_EDITOR then
			o.world.update(dt)
		elseif o.state == STATE_CREDITS then
			o.credits.update(dt)
		end
	end

	o.draw = function()
		if o.state == STATE_MAIN_MENU then
			o.menu.draw()
		elseif o.state == STATE_GAME or o.state == STATE_EDITOR then
			o.world.draw()
		elseif o.state == STATE_CREDITS then
			o.credits.draw()
		end
	end

	o.setState = function(state)
		o.state = state
		o.sound[1]:stop()
		o.sound[2]:stop()
		o.sound[3]:stop()
		if o.state == STATE_MAIN_MENU then
			o.sound[1]:play()
		elseif o.state == STATE_GAME then
			o.world.init()
			o.sound[2]:play()
		elseif o.state == STATE_EDITOR then
			o.world.init()
			o.world.enemyManager.ai = false
			o.world.shadows = false
		elseif o.state == STATE_CREDITS then
			o.sound[3]:play()
		end
	end

	o.setVersion = function(version)
		o.version = version
	end

	o.onKeyHit = function(key, code)
		if o.state == STATE_GAME then

		elseif o.state == STATE_EDITOR then
			local tx = (love.mouse.getX() - o.world.offsetX) / o.world.zoom
			local ty = (love.mouse.getY() - o.world.offsetY) / o.world.zoom
			
			if key == "f3" then
				o.world.shadows = not o.world.shadows
			elseif key == "f2" then
				o.world.save("map")
			elseif key == "f1" then
				o.world.load("map")
			elseif key == "q" then
				o.world.zoomIn()
			elseif key == "e" then
				o.world.zoomOut()
			elseif key == "1" then
				if #o.world.enemyManager.enemyTypes >= 1 then
					o.world.enemyManager.newEnemy(1, tx, ty)
				end
			elseif key == "2" then
				if #o.world.enemyManager.enemyTypes >= 2 then
					o.world.enemyManager.newEnemy(2, tx, ty)
				end
			elseif key == "3" then
				if #o.world.enemyManager.enemyTypes >= 3 then
					o.world.enemyManager.newEnemy(3, tx, ty)
				end
			elseif key == "4" then
				if #o.world.enemyManager.enemyTypes >= 4 then
					o.world.enemyManager.newEnemy(4, tx, ty)
				end
			elseif key == "5" then
				if #o.world.enemyManager.enemyTypes >= 5 then
					o.world.enemyManager.newEnemy(5, tx, ty)
				end
			elseif key == "6" then
				if #o.world.itemManager.itemTypes >= 1 then
					o.world.itemManager.newItem(1, tx, ty)
				end
			elseif key == "7" then
				if #o.world.itemManager.itemTypes >= 2 then
					o.world.itemManager.newItem(2, tx, ty)
				end
			elseif key == "8" then
				if #o.world.itemManager.itemTypes >= 3 then
					o.world.itemManager.newItem(3, tx, ty)
				end
			elseif key == "9" then
				if #o.world.itemManager.itemTypes >= 4 then
					o.world.itemManager.newItem(4, tx, ty)
				end
			elseif key == "0" then
				if #o.world.itemManager.itemTypes >= 5 then
					o.world.itemManager.newItem(5, tx, ty)
				end
			elseif key == "delete" then
				o.world.enemyManager.deleteEnemy(tx, ty)
				o.world.itemManager.deleteItem(tx, ty)
			end
		end
	end

	o.onMouseHit = function(x, y, key)
		if o.state == STATE_GAME then
			if key == "wd" then
				o.world.zoomOut()
			elseif key == "wu" then
				o.world.zoomIn()
			end
		elseif o.state == STATE_EDITOR then
			if key == "wu" then
				o.world.tileID = math.max(0, o.world.tileID - 1)
			elseif key == "wd" then
				o.world.tileID = math.min(o.world.tileID + 1, 63)
			end
			if key == "l" then
				o.world.drawTile = true
			end
		end
	end

	o.onMouseUp = function(x, y, key)
		if o.state == STATE_EDITOR then
			if key == "l" then
				o.world.drawTile = false
			end
		end
	end

	return o
end
