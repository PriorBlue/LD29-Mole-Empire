require "lib/map"
require "lib/player"

function love.game.newWorld(parent)
	local o = {}

	o.parent = parent
	o.mapWidth = 256
	o.mapHeight = 256
	o.tileset = nil
	o.map = nil
	o.player = nil
	o.layer = {}
	o.tileID = 0
	o.drawTile = false
	o.shadows = true

	o.zoom = 2
	o.dragX = 0
	o.dragY = 0

	o.offsetX = 0
	o.offsetY = 0

	o.init = function()
		o.map = love.game.newMap(o.mapWidth, o.mapHeight)
		o.tileset = love.game.newTileset("gfx/tileset.png", 8)
		o.layer[1] = o.map.addLayer(o.tileset)
		o.layer[2] = o.map.addLayer(o.tileset)
		o.layer[3] = o.map.addLayer(o.tileset)
		o.layer[3].shadow = true
		--o.layer[1].clear(11, 0, 0)
		o.load("map")
		o.player = love.game.newPlayer(o, 0, 0)
	end

	o.update = function(dt)
		o.player.update(dt)
		-- center player
		o.offsetX = -o.player.x * o.zoom + W.getWidth() * 0.5
		o.offsetY = -o.player.y * o.zoom + W.getHeight() * 0.5
		
		o.layer[3].setLightPosition(o.player.x, o.player.y)
		if love.keyboard.isDown("escape") then
			o.parent.setState(STATE_MAIN_MENU)
		end
		if o.drawTile then
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
				end

				o.layer[i].endDraw()
			end
		end
	end

	o.draw = function()
		G.setColor(255, 255, 255)
		o.layer[1].draw(o.offsetX, o.offsetY, 0, o.zoom , o.zoom)
		o.layer[2].draw(o.offsetX, o.offsetY,0, o.zoom, o.zoom)
		o.player.draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		if o.shadows then
			o.layer[3].draw(o.offsetX, o.offsetY, 0, o.zoom, o.zoom)
		end
		G.draw(o.tileset.img, W.getWidth() - o.tileset.img:getWidth())
		-- draw tile selector
		G.setColor(255, 255, 0)
		G.rectangle("line", W.getWidth() - o.tileset.img:getWidth() + (o.tileID % o.tileset.grid) * o.tileset.tileWidth, math.floor(o.tileID / o.tileset.grid) * o.tileset.tileHeight, o.tileset.tileWidth, o.tileset.tileHeight)
		-- draw mouse marker
		G.setColor(255, 0, 0)
		G.rectangle("line", math.floor((love.mouse.getX() - o.offsetX) / (o.tileset.tileWidth * o.zoom)) * o.tileset.tileWidth * o.zoom + o.offsetX, math.floor((love.mouse.getY() - o.offsetY) / (o.tileset.tileHeight * o.zoom)) * o.tileset.tileHeight * o.zoom + o.offsetY, o.tileset.tileWidth * o.zoom, o.tileset.tileHeight * o.zoom)
	end

	o.load = function(path)
		o.map.load(path)
	end

	o.save = function(path)
		o.map.save(path)
	end

	o.zoomIn = function(zoom)
		zoom = zoom or 2

		if o.zoom < 4 then
			o.zoom = o.zoom * zoom

			o.offsetX = o.offsetX - (love.mouse.getX() - o.offsetX)
			o.offsetY = o.offsetY - (love.mouse.getY() - o.offsetY)
		end
	end

	o.zoomOut = function(zoom)
		zoom = zoom or 0.5

		if o.zoom > 0.125 then
			o.zoom = o.zoom * zoom

			o.offsetX = o.offsetX + (love.mouse.getX() - o.offsetX) * 0.5
			o.offsetY = o.offsetY + (love.mouse.getY() - o.offsetY) * 0.5
		end
	end

	return o
end