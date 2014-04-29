LOVE_LAYER_LAST_CANVAS = nil

function love.game.newTileset(path, grid)
	local o = {}

	if love.filesystem.isFile(path) then
		o.img = G.newImage(path)
		o.grid = grid
		o.tileWidth = o.img:getWidth() / o.grid
		o.tileHeight = o.img:getHeight() / o.grid
	else
		-- Test --
		local files = love.filesystem.getDirectoryItems(path)
		local img = G.newImage(path .. "/" .. files[1])
		o.tileWidth = img:getWidth()
		o.tileHeight = img:getHeight()

		local n = 0

		for i, file in ipairs(files) do
			img = G.newImage(path .. "/" .. file)
			for k = 1, img:getHeight() / o.tileHeight do
				for l = 1, img:getWidth() / o.tileWidth do
					n = n + 1
				end
			end
		end

		local count = n ^ 0.5

		for i = 1, 12 do
			if count < 2 ^ i then
				o.grid = 2 ^ i
				break
			end
		end

		local imgData = love.image.newImageData(o.tileWidth * o.grid, o.tileHeight * o.grid)

		n = 0

		for i, file in ipairs(files) do
			img = G.newImage(path .. "/" .. file)
			for k = 1, img:getHeight() / o.tileHeight do
				for l = 1, img:getWidth() / o.tileWidth do
					imgData:paste(img:getData(), (n % o.grid) * o.tileWidth, math.floor(n / o.grid) * o.tileHeight, (l - 1) * o.tileHeight, (k - 1) * o.tileWidth, o.tileWidth, o.tileHeight)
					n = n + 1
				end
			end
		end

		o.img = G.newImage(imgData)
	end
	o.img:setFilter("nearest", "nearest")

	return o
end

function love.game.newLayer(parent, width, height, tileset)
	local o = {}

	o.parent = parent
	o.width = width
	o.height = height
	o.tileset = tileset
	o.canvas = G.newCanvas(o.width, o.height)
	o.canvas:setFilter("nearest", "nearest")
	o.shader = G.newShader("shader/tileset.glsl")
	o.shader:send("tileset", o.tileset.img)
	o.shader:send("grid", o.tileset.grid)
	o.shader:send("size", {o.width, o.height})
	o.shader2 = G.newShader("shader/tileset_shadow.glsl")
	o.shader2:send("tileset", o.tileset.img)
	o.shader2:send("grid", o.tileset.grid)
	o.shader2:send("size", {o.width, o.height})
	o.lightX = 0
	o.lightY = 0
	o.coll = {1, 2, 3, 4, 5, 8, 9, 10, 12, 13, 16, 17, 18, 19, 20} --HARDCODE
	o.curEvent = 0
	o.shadow = false

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		if o.shadow then
			o.shader2:send("lightPosition", {o.lightX, o.lightY})
			o.shader2:send("screenSize", {o.width * o.tileset.tileWidth, o.height * o.tileset.tileHeight})
			o.shader2:send("time", math.floor(love.timer.getTime() * 5))
			o.shader2:send("zoom", math.min(1, sw))
			G.setShader(o.shader2)
			G.setBlendMode("multiplicative")
		else
			o.shader:send("time", math.floor(love.timer.getTime() * 5))
			G.setShader(o.shader)
			G.setBlendMode("alpha")
		end
		G.draw(o.canvas, x or 0, y or 0, r or 0, (sw or 1) * 16, (sh or 1) * 16, ...)
		G.setBlendMode("alpha")
		G.setShader()
	end

	o.startDraw = function()
		LOVE_LAYER_LAST_CANVAS = G.getCanvas()
		G.setShader()
		G.setCanvas(o.canvas)
		G.setBlendMode("replace")
	end

	o.endDraw = function()
		G.setCanvas(LOVE_LAYER_LAST_CANVAS)
		G.setBlendMode("alpha")
	end

	o.setTile = function(x, y, n, frames, event)
		local coll = false
		o.curEvent = event or 0
		for i = 1, #o.coll do
			if o.coll[i] == n then
				o.curEvent = 1
				coll = true
				break
			end
		end
		o.parent.setCollision(x, y, coll)
		G.setPointStyle("rough")
		G.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0, o.curEvent)
		G.point(x, y)
	end

	o.getTile = function(x, y)
		local r, g, b, a = o.canvas:getPixel(x, y)
		return r + g * o.tileset.grid
	end

	o.getFrames = function(x, y)
		local r, g, b, a = o.canvas:getPixel(x, y)
		return b
	end

	o.getEvent = function(x, y)
		local r, g, b, a = o.canvas:getPixel(x, y)
		return a
	end

	o.setTileRectangle = function(x, y, width, height, n, frames, event)
		G.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0, event or 0)
		G.rectangle("fill", x, y, width, height)
	end

	o.setTileCircle = function(x, y, r, n, frames, event)
		G.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0, event or 0)
		G.circle("fill", x, y, r)
	end

	o.setLightPosition = function(x, y)
		o.lightX = x
		o.lightY = y
	end

	o.clear = function(n, frames, event)
		o.canvas:clear(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0, event or 0)
	end

	return o
end

function love.game.newMap(width, height)
	local o = {}

	o.layer = {}
	o.width = width or 256
	o.height = height or 256
	o.collision = {}
	for i = 1, o.width do
		o.collision[i] = {}
		for k = 1, o.height do
			o.collision[i][k] = false
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		G.setColor(255, 255, 255)
		for i = 1, #o.layer do
			o.layer[i].draw(x, y, r, sw, sh, ...)
		end
		G.setShader()
	end

	o.addLayer = function(tileset)
		o.layer[#o.layer + 1] = love.game.newLayer(o, o.width, o.height, tileset)

		return o.layer[#o.layer]
	end

	o.load = function(path)
		G.setColor(255, 255, 255)
		G.setBlendMode("replace")
		LOVE_LAYER_LAST_CANVAS = G.getCanvas()
		for i = 1, #o.layer do
			local img = G.newImage("save/" .. path .. "_" .. i .. ".png")

			G.setCanvas(o.layer[i].canvas)
			G.draw(img)
			-- update collision
			local imgData = img:getData()
			for k = 1, o.width do
				for l = 1, o.height do
					local r, g, b, a = imgData:getPixel(k - 1, l - 1)
					if a > 0 then
						o.collision[k][l] = true
					else
						o.collision[k][l] = false
					end
				end
			end
		end
		G.setCanvas(LOVE_LAYER_LAST_CANVAS)
		G.setBlendMode("alpha")
	end

	o.save = function(path)
		FS.createDirectory("save")

		for i = 1, #o.layer do
			o.layer[i].canvas:getImageData():encode("save/" .. path .. "_" .. i .. ".png")
		end
	end

	o.isCollision = function(x, y)
		if x >= 1 and y >= 1 and x <= o.width and y <= o.height then
			return o.collision[math.floor(x)][math.floor(y)]
		else
			return true
		end
	end

	o.setCollision = function(x, y, collision)
		if x >= 1 and y >= 1 and x <= o.width and y <= o.height then
			o.collision[math.floor(x)][math.floor(y)] = collision
		end
	end

	return o
end