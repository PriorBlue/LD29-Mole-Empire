require "lib/map"
require "lib/player"
require "lib/enemy_manager"
require "lib/item_manager"
require "lib/hit_manager"
require "lib/hud"

function love.game.newWorld(parent)
	local o = {}

	o.parent = parent
	o.mapWidth = 256
	o.mapHeight = 256
	o.tileset = love.game.newTileset("gfx/tileset.png", 8)
	o.tileset_shadow = love.game.newTileset("gfx/tileset_shadow.png", 8)
	o.map = love.game.newMap(o.mapWidth, o.mapHeight)
	o.player = love.game.newPlayer(o, 128, 128)
	o.enemyManager = love.game.newEnemyManager(o)
	o.itemManager = love.game.newItemManager(o)
	o.hitManager = love.game.newHitManager(o)
	o.layer = {}
	o.layer[1] = o.map.addLayer(o.tileset)
	o.layer[2] = o.map.addLayer(o.tileset)
	o.layer[3] = o.map.addLayer(o.tileset_shadow)
	o.layer[3].shadow = true
	o.hud = love.game.newHud(o, 8, 8)
	o.tileID = 0
	o.drawTile = false
	o.shadows = true
	o.timer = 0
	o.timerDeath = 0
	o.timerWin = 0

	o.zoom = 2
	o.dragX = 0
	o.dragY = 0

	o.offsetX = 0
	o.offsetY = 0

	o.init = function()
		--o.layer[1].clear(11, 0, 0)
		o.enemyManager.init()
		o.itemManager.init()
		o.zoom = 2
		o.load("map")
		o.player.init()
		o.hud.maxHealth = o.player.maxHealth
		o.hud.health = o.player.health
		o.hud.maxAttack = o.player.maxAttack
		o.hud.attack = o.player.attack
		o.shadows = true
		o.timer = 0
		o.timerDeath = 0
	end

	o.update = function(dt)
		o.timer = o.timer + dt

		o.enemyManager.update(dt)
		o.itemManager.update(dt)
		o.hitManager.update(dt)

		if o.parent.state == STATE_GAME then
			if o.player.health > 0 then
				if o.enemyManager.getEnemyKillCount() < o.enemyManager.getEnemyCount() then
					o.player.update(dt)
				else
					o.timerWin = o.timerWin + dt
				end
			else
				o.timerDeath = o.timerDeath + dt
			end

			o.hud.maxHealth = o.player.maxHealth
			o.hud.health = math.max(0, o.player.health)
			o.hud.attack = o.player.attack
			-- center player
			o.offsetX = -o.player.x * o.zoom + W.getWidth() * 0.5
			o.offsetY = -o.player.y * o.zoom + W.getHeight() * 0.5
		elseif o.parent.state == STATE_EDITOR then
			if love.keyboard.isDown("w") then
				o.offsetY = o.offsetY + dt * 200
			elseif love.keyboard.isDown("s") then
				o.offsetY = o.offsetY - dt * 200
			end

			if love.keyboard.isDown("a") then
				o.offsetX = o.offsetX + dt * 200
			elseif love.keyboard.isDown("d") then
				o.offsetX = o.offsetX - dt * 200
			end
		end

		if o.parent.state == STATE_GAME then
			o.layer[3].setLightPosition(o.player.x, o.player.y)
		elseif o.parent.state == STATE_EDITOR then
			o.layer[3].setLightPosition((love.mouse.getX() - o.offsetX) / o.zoom, (love.mouse.getY() - o.offsetY) / o.zoom)
		end

		if love.keyboard.isDown("escape") then
			o.parent.setState(STATE_MAIN_MENU)
		end

		if o.parent.state == STATE_EDITOR and o.drawTile then
			local tx = ((love.mouse.getX() - o.offsetX) / o.zoom) / o.tileset.tileWidth
			local ty = ((love.mouse.getY() - o.offsetY) / o.zoom) / o.tileset.tileHeight

			for i = 2, 3 do
				o.layer[i].startDraw()
				-- HARDCODE EVENT ID'S --
				o.layer[i].setTile(tx, ty, o.tileID, 0)
				-- HARDCODE EDGES --
				if o.tileID == 0 then
					if o.layer[i].getTile(tx - 1, ty) == 1 or o.layer[i].getTile(tx - 1, ty) == 2 or o.layer[i].getTile(tx - 1, ty) == 18 then
						o.layer[i].setTile(tx - 1, ty, 10)
					end
					if o.layer[i].getTile(tx + 1, ty) == 1 or o.layer[i].getTile(tx + 1, ty) == 4 or o.layer[i].getTile(tx + 1, ty) == 20 then
						o.layer[i].setTile(tx + 1, ty, 12)
					end
					if o.layer[i].getTile(tx, ty - 1) == 1 or o.layer[i].getTile(tx, ty - 1) == 2 or o.layer[i].getTile(tx, ty - 1) == 4 then
						o.layer[i].setTile(tx, ty - 1, 3)
					end
					if o.layer[i].getTile(tx, ty + 1) == 1 or o.layer[i].getTile(tx, ty + 1) == 18 or o.layer[i].getTile(tx, ty + 1) == 20 then
						o.layer[i].setTile(tx, ty + 1, 19)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 1 then
						o.layer[i].setTile(tx - 1, ty - 1, 2)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 1 then
						o.layer[i].setTile(tx + 1, ty - 1, 4)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 1 then
						o.layer[i].setTile(tx - 1, ty + 1, 18)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 1 then
						o.layer[i].setTile(tx + 1, ty + 1, 20)
					end

					if o.layer[i].getTile(tx - 1, ty) == 3 then
						o.layer[i].setTile(tx - 1, ty, 17)
					elseif o.layer[i].getTile(tx - 1, ty) == 19 then
						o.layer[i].setTile(tx - 1, ty, 9)
					end
					if o.layer[i].getTile(tx + 1, ty) == 3 then
						o.layer[i].setTile(tx + 1, ty, 16)
					elseif o.layer[i].getTile(tx + 1, ty) == 19 then
						o.layer[i].setTile(tx + 1, ty, 8)
					end
					if o.layer[i].getTile(tx, ty - 1) == 10 then
						o.layer[i].setTile(tx, ty - 1, 17)
					elseif o.layer[i].getTile(tx, ty - 1) == 12 then
						o.layer[i].setTile(tx, ty - 1, 16)
					end
					if o.layer[i].getTile(tx, ty + 1) == 10 then
						o.layer[i].setTile(tx, ty + 1, 9)
					elseif o.layer[i].getTile(tx, ty + 1) == 12 then
						o.layer[i].setTile(tx, ty + 1, 8)
					end

					if o.layer[i].getTile(tx - 1, ty) == 8 or o.layer[i].getTile(tx - 1, ty) == 16 or o.layer[i].getTile(tx - 1, ty) == 12 then
						o.layer[i].setTile(tx - 1, ty, 0)
					end
					if o.layer[i].getTile(tx + 1, ty) == 9 or o.layer[i].getTile(tx + 1, ty) == 17 or o.layer[i].getTile(tx + 1, ty) == 10 then
						o.layer[i].setTile(tx + 1, ty, 0)
					end
					if o.layer[i].getTile(tx, ty - 1) == 8 or o.layer[i].getTile(tx, ty - 1) == 9 or o.layer[i].getTile(tx, ty - 1) == 19 then
						o.layer[i].setTile(tx, ty - 1, 0)
					end
					if o.layer[i].getTile(tx, ty + 1) == 16 or o.layer[i].getTile(tx, ty + 1) == 17 or o.layer[i].getTile(tx, ty + 1) == 3 then
						o.layer[i].setTile(tx, ty + 1, 0)
					end
				elseif o.tileID == 1 then
					if o.layer[i].getTile(tx - 1, ty) == 0 or o.layer[i].getTile(tx - 1, ty) == 8 or o.layer[i].getTile(tx - 1, ty) == 16 then
						o.layer[i].setTile(tx - 1, ty, 12)
					end
					if o.layer[i].getTile(tx + 1, ty) == 0 or o.layer[i].getTile(tx + 1, ty) == 9 or o.layer[i].getTile(tx + 1, ty) == 17 then
						o.layer[i].setTile(tx + 1, ty, 10)
					end
					if o.layer[i].getTile(tx, ty - 1) == 0 or o.layer[i].getTile(tx, ty - 1) == 8 or o.layer[i].getTile(tx, ty - 1) == 9 then
						o.layer[i].setTile(tx, ty - 1, 19)
					end
					if o.layer[i].getTile(tx, ty + 1) == 0 or o.layer[i].getTile(tx, ty + 1) == 16 or o.layer[i].getTile(tx, ty + 1) == 17 then
						o.layer[i].setTile(tx, ty + 1, 3)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 0 then
						o.layer[i].setTile(tx - 1, ty - 1, 8)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 0 then
						o.layer[i].setTile(tx + 1, ty - 1, 9)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 0 then
						o.layer[i].setTile(tx - 1, ty + 1, 16)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 0 then
						o.layer[i].setTile(tx + 1, ty + 1, 17)
					end

					if o.layer[i].getTile(tx - 1, ty) == 3 then
						o.layer[i].setTile(tx - 1, ty, 4)
					end
					if o.layer[i].getTile(tx - 1, ty) == 19 then
						o.layer[i].setTile(tx - 1, ty, 20)
					end
					if o.layer[i].getTile(tx + 1, ty) == 3 then
						o.layer[i].setTile(tx + 1, ty, 2)
					end
					if o.layer[i].getTile(tx + 1, ty) == 19 then
						o.layer[i].setTile(tx + 1, ty, 18)
					end

					if o.layer[i].getTile(tx, ty - 1) == 12 then
						o.layer[i].setTile(tx, ty - 1, 20)
					end
					if o.layer[i].getTile(tx, ty - 1) == 10 then
						o.layer[i].setTile(tx, ty - 1, 18)
					end
					if o.layer[i].getTile(tx, ty + 1) == 12 then
						o.layer[i].setTile(tx, ty + 1, 4)
					end
					if o.layer[i].getTile(tx, ty + 1) == 10 then
						o.layer[i].setTile(tx, ty + 1, 2)
					end

					if o.layer[i].getTile(tx - 1, ty) == 0 or o.layer[i].getTile(tx - 1, ty) == 10 then
						o.layer[i].setTile(tx - 1, ty, 1)
					end
					if o.layer[i].getTile(tx + 1, ty) == 0 or o.layer[i].getTile(tx + 1, ty) == 12 then
						o.layer[i].setTile(tx + 1, ty, 1)
					end
					if o.layer[i].getTile(tx, ty - 1) == 0 or o.layer[i].getTile(tx, ty - 1) == 3 then
						o.layer[i].setTile(tx, ty - 1, 1)
					end
					if o.layer[i].getTile(tx, ty + 1) == 0 or o.layer[i].getTile(tx, ty + 1) == 19 then
						o.layer[i].setTile(tx, ty + 1, 1)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 10 then
						o.layer[i].setTile(tx - 1, ty - 1, 18)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 12 then
						o.layer[i].setTile(tx + 1, ty - 1, 20)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 10 then
						o.layer[i].setTile(tx - 1, ty + 1, 2)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 12 then
						o.layer[i].setTile(tx + 1, ty + 1, 4)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 3 then
						o.layer[i].setTile(tx - 1, ty - 1, 4)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 3 then
						o.layer[i].setTile(tx + 1, ty - 1, 2)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 19 then
						o.layer[i].setTile(tx - 1, ty + 1, 20)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 19 then
						o.layer[i].setTile(tx + 1, ty + 1, 18)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 9 then
						o.layer[i].setTile(tx - 1, ty - 1, 19)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 8 then
						o.layer[i].setTile(tx + 1, ty - 1, 19)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 17 then
						o.layer[i].setTile(tx - 1, ty + 1, 3)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 16 then
						o.layer[i].setTile(tx + 1, ty + 1, 3)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 16 then
						o.layer[i].setTile(tx - 1, ty - 1, 12)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 17 then
						o.layer[i].setTile(tx + 1, ty - 1, 10)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 8 then
						o.layer[i].setTile(tx - 1, ty + 1, 12)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 9 then
						o.layer[i].setTile(tx + 1, ty + 1, 10)
					end

					if o.layer[i].getTile(tx - 1, ty - 1) == 2 then
						o.layer[i].setTile(tx - 1, ty - 1, 1)
					end
					if o.layer[i].getTile(tx + 1, ty - 1) == 4 then
						o.layer[i].setTile(tx + 1, ty - 1, 1)
					end
					if o.layer[i].getTile(tx - 1, ty + 1) == 18 then
						o.layer[i].setTile(tx - 1, ty + 1, 1)
					end
					if o.layer[i].getTile(tx + 1, ty + 1) == 20 then
						o.layer[i].setTile(tx + 1, ty + 1, 1)
					end

					if o.layer[i].getTile(tx - 1, ty) == 9 then
						o.layer[i].setTile(tx - 1, ty, 20)
					end
					if o.layer[i].getTile(tx - 1, ty) == 17 then
						o.layer[i].setTile(tx - 1, ty, 4)
					end
					if o.layer[i].getTile(tx + 1, ty) == 8 then
						o.layer[i].setTile(tx + 1, ty, 18)
					end
					if o.layer[i].getTile(tx + 1, ty) == 16 then
						o.layer[i].setTile(tx + 1, ty, 2)
					end

					if o.layer[i].getTile(tx , ty - 1) == 16 then
						o.layer[i].setTile(tx, ty - 1, 20)
					end
					if o.layer[i].getTile(tx, ty - 1) == 17 then
						o.layer[i].setTile(tx, ty - 1, 18)
					end
					if o.layer[i].getTile(tx, ty + 1) == 8 then
						o.layer[i].setTile(tx, ty + 1, 4)
					end
					if o.layer[i].getTile(tx, ty + 1) == 9 then
						o.layer[i].setTile(tx, ty + 1, 2)
					end

					if o.layer[i].getTile(tx , ty - 1) == 2 or o.layer[i].getTile(tx , ty - 1) == 4 then
						o.layer[i].setTile(tx, ty - 1, 1)
					end
					if o.layer[i].getTile(tx, ty + 1) == 18 or o.layer[i].getTile(tx, ty + 1) == 20 then
						o.layer[i].setTile(tx, ty + 1, 1)
					end
					if o.layer[i].getTile(tx - 1, ty) == 2 or o.layer[i].getTile(tx - 1, ty) == 18 then
						o.layer[i].setTile(tx - 1, ty, 1)
					end
					if o.layer[i].getTile(tx + 1, ty) == 4 or o.layer[i].getTile(tx + 1, ty) == 20 then
						o.layer[i].setTile(tx + 1, ty, 1)
					end
				end

				o.layer[i].endDraw()
			end
		end
	end

	o.draw = function()
		G.setColor(255, 255, 255)
		o.layer[1].draw(o.offsetX, o.offsetY, 0, o.zoom , o.zoom)
		o.layer[2].draw(o.offsetX, o.offsetY,0, o.zoom, o.zoom)

		o.enemyManager.drawBottom(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)

		if o.parent.state == STATE_GAME then
			o.player.draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		end

		o.enemyManager.drawTop(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		o.itemManager.draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		o.hitManager.draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)

		if o.parent.state == STATE_GAME then
			o.player.drawAttack(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		end

		if o.parent.state == STATE_GAME or o.shadows then
			o.layer[3].draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		end
		
		if o.parent.state == STATE_EDITOR then
			-- draw tileset
			G.setColor(255, 255, 255, 31)
			G.rectangle("fill", W.getWidth() - o.tileset.img:getWidth() - 16, 0, o.tileset.img:getWidth() + 16, o.tileset.img:getHeight() + 16)
			G.setColor(255, 255, 255)
			G.draw(o.tileset.img, W.getWidth() - o.tileset.img:getWidth() - 8, 8)
			-- draw tile selector
			G.setColor(255, 255, 0)
			G.rectangle("line", W.getWidth() - o.tileset.img:getWidth() + (o.tileID % o.tileset.grid) * o.tileset.tileWidth - 8, math.floor(o.tileID / o.tileset.grid) * o.tileset.tileHeight + 8, o.tileset.tileWidth, o.tileset.tileHeight)
			-- draw mouse marker
			G.setColor(255, 0, 0)
			G.rectangle("line", math.floor((love.mouse.getX() - o.offsetX) / (o.tileset.tileWidth * o.zoom)) * o.tileset.tileWidth * o.zoom + o.offsetX, math.floor((love.mouse.getY() - o.offsetY) / (o.tileset.tileHeight * o.zoom)) * o.tileset.tileHeight * o.zoom + o.offsetY, o.tileset.tileWidth * o.zoom, o.tileset.tileHeight * o.zoom)
		end

		if o.parent.state == STATE_GAME then
			if ludGame.world.player.attacked > 0.5 then
				local colorAberration1 = math.sin(love.timer.getTime() * 20.0) * (ludGame.world.player.attacked - 0.5) * 4.0
				local colorAberration2 = math.cos(love.timer.getTime() * 20.0) * (ludGame.world.player.attacked - 0.5) * 4.0

				love.postshader.addEffect("blur", 2.0, 2.0)
				love.postshader.addEffect("chromatic", colorAberration1, colorAberration2, colorAberration2, -colorAberration1, colorAberration1, -colorAberration2)
			end

			o.hud.draw()

			if o.timer < 5 then
				G.setColor(191, 255, 0, (o.timer % 5) * 25)
				G.printf("[QUICK HELP]\nWASD: Move\nSPACE: Attack\nE: Interact", 0, 8, W.getWidth(), "center")
			elseif o.timer < 10 then
				G.setColor(255, 191, 0, (o.timer % 5) * 25)
				G.printf("Kill all enemies, to become the leader of the underworld!", 0, 8, W.getWidth(), "center")
			end

			if o.timerDeath > 0 then
				G.setColor(0, 0, 0, math.min(o.timerDeath * 100, 191))
				G.rectangle("fill", 0, 0, W.getWidth(), W.getHeight())
				G.setColor(255, 63, 0, math.min(o.timerDeath * 100, 255))
				G.setFont(FONT_NORMAL)
				G.printf("You are dead!", 0, W.getHeight() * 0.5, W.getWidth(), "center")
			elseif o.enemyManager.getEnemyKillCount() >= o.enemyManager.getEnemyCount() then
				G.setColor(0, 0, 0, math.min(o.timerWin * 100, 191))
				G.rectangle("fill", 0, 0, W.getWidth(), W.getHeight())
				G.setColor(63, 255, 0, math.min(o.timerWin * 100, 255))
				G.setFont(FONT_NORMAL)
				G.printf("Wow, you realy did it!\nYou are now the ruler of this hole.", 0, W.getHeight() * 0.5 - 32, W.getWidth(), "center")
			end
		elseif o.parent.state == STATE_EDITOR then
			G.setFont(FONT_SMALL)
			G.setColor(0, 0, 0, 191)
			G.rectangle("fill", 0, W.getHeight() - 64, W.getWidth(), 64)
			G.setColor(255, 255, 255)
			G.printf("[F1]Load [F2]Save [F3]Shadow on/off [Mouse-Scroll] Select Tile\n\n[Q/E] Zoom [1-5] Add enemies [6-0] Add items [Delete] Remove enemies/items", 0, W.getHeight() - 56, W.getWidth(), "center")
		end
	end

	o.load = function(path)
		o.map.load(path)
		o.enemyManager.load(path)
		o.itemManager.load(path)
	end

	o.save = function(path)
		o.map.save(path)
		o.enemyManager.save(path)
		o.itemManager.save(path)
	end

	o.zoomIn = function(zoom)
		zoom = zoom or 2

		if o.zoom < 4 or (o.parent.state == STATE_EDITOR and o.zoom < 8) then
			o.zoom = o.zoom * zoom

			o.offsetX = o.offsetX - (love.mouse.getX() - o.offsetX)
			o.offsetY = o.offsetY - (love.mouse.getY() - o.offsetY)
		end
	end

	o.zoomOut = function(zoom)
		zoom = zoom or 0.5

		if o.zoom > 1 or (o.parent.state == STATE_EDITOR and o.zoom > 0.125) then
			o.zoom = o.zoom * zoom

			o.offsetX = o.offsetX + (love.mouse.getX() - o.offsetX) * 0.5
			o.offsetY = o.offsetY + (love.mouse.getY() - o.offsetY) * 0.5
		end
	end

	return o
end