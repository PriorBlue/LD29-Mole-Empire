require "lib/item"

function love.game.newItemManager(parent)
	local o = {}

	o.parent = parent
	o.id = 0
	o.quadItems = G.newQuad(0, 0, 8, 8, 64, 64)
	o.imgItems = G.newImage("gfx/items.png")
	o.sound = love.audio.newSource("sfx/item.wav", "static")
	o.itemTypes = nil
	o.items = nil
	o.imgBatch = G.newSpriteBatch(o.imgItems, 1000)

	o.init = function()
		o.itemTypes = Tserial.unpack(love.filesystem.read("data/item.ini"))
		o.items = {}
	end

	o.update = function(dt)
		local p = o.parent.player

		for i = 1, #o.items do
			local itm = o.items[i]

			local len = math.length(itm.x, itm.y, p.x, p.y)

			if len <= 8 then
				if o.itemTypes[itm.type].health then
					p.addHealth(o.itemTypes[itm.type].health)
				end
				if o.itemTypes[itm.type].maxHealth then
					p.maxHealth = p.maxHealth + o.itemTypes[itm.type].maxHealth
					p.addHealth(o.itemTypes[itm.type].maxHealth)
				end
				if o.itemTypes[itm.type].speed then
					p.speed = p.speed + o.itemTypes[itm.type].speed
				end
				if o.itemTypes[itm.type].strength then
					p.strength = p.strength + o.itemTypes[itm.type].strength
				end
				if o.itemTypes[itm.type].luck then
					p.luck = p.luck + o.itemTypes[itm.type].luck
				end

				o.sound:play()

				table.remove(o.items, i)
				--o.imgBatch:set(o.id, 0, 0)
				break
			end

			itm.update(dt)
		end
	end

	o.draw = function(x, y, r, sw, sh, ...)
		for i = 1, #o.items do
			o.items[i].draw(x, y, r, sw, sh, ...)
		end
		--G.setColor(255, 255, 255)
		--G.setBlendMode("alpha")
		--G.draw(o.imgBatch, x, y, 0, sw, sh)
	end

	o.load = function(path)
		local items = Tserial.unpack(love.filesystem.read("save/" .. path .. "_items.ini"))

		for i = 1, #items do
			o.newItem(items[i].type, items[i].x, items[i].y)
		end
	end

	o.save = function(path)
		local items = {}

		for i = 1, #o.items do
			items[i] = {}
			items[i].type = o.items[i].type or 1
			items[i].x = o.items[i].x or 0
			items[i].y = o.items[i].y or 0
		end

		FS.createDirectory("save")
		love.filesystem.write("save/" .. path .. "_items.ini", Tserial.pack(items))
		print("saved!")
	end

	o.newItem = function(type, x, y)
		local itm = love.game.newItem(o, type, x, y)
		itm.imageID = o.itemTypes[type].imageID or 0
		itm.health = o.itemTypes[type].health or 0
		itm.maxHealth = o.itemTypes[type].maxHealth or 0
		itm.strength = o.itemTypes[type].strength or 0
		itm.luck = o.itemTypes[type].luck or 0
		itm.speed = o.itemTypes[type].speed or 0

		o.items[#o.items + 1] = itm
		o.quadItems:setViewport(itm.imageID * 8, 0, 8, 8)
		--o.id = o.imgBatch:add(o.quadItems, x, y)

		return o.items[#o.items]
	end

	o.deleteItem = function(x, y)
		for i = 1, #o.items do
			local itm = o.items[i]

			if math.length(itm.x, itm.y, x, y) < 16 then
				table.remove(o.items, i)
				o.imgBatch:set(o.id, 0, 0)
				break
			end
		end
	end

	return o
end