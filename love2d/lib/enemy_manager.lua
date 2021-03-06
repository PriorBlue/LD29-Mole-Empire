require "lib/enemy"

function love.game.newEnemyManager(parent)
	local o = {}

	o.parent = parent
	o.quad = G.newQuad(0, 24, 16, 24, 64, 120)
	o.quadAttack = G.newQuad(0, 0, 16, 16, 64, 16)
	o.imgEnemies = {}
	o.imgAttack = {}
	o.imgAttack[1] = G.newImage("gfx/attack.png")
	o.soundAttack = {}
	o.enemyTypes = nil
	o.enemies = nil
	o.ai = true

	o.init = function()
		o.enemyTypes = Tserial.unpack(love.filesystem.read("data/enemy.ini"))

		for i = 1, #o.enemyTypes do
			o.imgEnemies[i] = G.newImage("gfx/" .. o.enemyTypes[i].image)
			o.soundAttack[i] = A.newSource("sfx/" .. o.enemyTypes[i].attackSound, "static")
		end
		
		o.enemies = {}
		o.ai = true
	end

	o.update = function(dt)
		if o.ai then
			local p = o.parent.player

			for i = 1, #o.enemies do
				local e = o.enemies[i]

				if not e.death then
					local len = math.length(e.x, e.y, p.x, p.y)

					if len <= 256 then
						if len <= 64 then
							e.target = p
							if len <= 16 and p.attacked <= 0 then
								local dmg = (e.strength + math.random(0, e.luck))
								p.health = p.health - dmg
								p.attacked = 1.0
								o.soundAttack[e.type]:play()
								o.parent.hitManager.addHit(p.x, p.y - 16, dmg, 255, 63, 0)
							end
						else
							e.target = nil
							if math.length(e.x, e.y, e.x2, e.y2) <= 4 then
								--if math.random(0, 1) == 1 then
									e.moveTo(e.x2 + math.random(-64, 64), e.y2 + math.random(-64, 64))
								--else
									--e.moveTo(e.x2 + math.random(-64, 64), e.y2)
								--end
							end
						end
					end
				end
				e.update(dt)
			end
		end
	end

	o.load = function(path)
		local enemies = Tserial.unpack(love.filesystem.read("save/" .. path .. "_enemies.ini"))

		for i = 1, #enemies do
			o.newEnemy(enemies[i].type, enemies[i].x, enemies[i].y)
		end
	end

	o.save = function(path)
		local enemies = {}

		for i = 1, #o.enemies do
			enemies[i] = {}
			enemies[i].type = o.enemies[i].type or 1
			enemies[i].x = o.enemies[i].x or 0
			enemies[i].y = o.enemies[i].y or 0
		end

		FS.createDirectory("save")
		love.filesystem.write("save/" .. path .. "_enemies.ini", Tserial.pack(enemies))
		print("saved!")
	end

	o.drawBottom = function(x, y, r, sw, sh, ...)
		for i = 1, #o.enemies do
			if o.enemies[i].y <= o.parent.player.y then
				o.enemies[i].draw(x, y, r, sw, sh, ...)
			end
		end
	end

	o.drawTop = function(x, y, r, sw, sh, ...)
		for i = 1, #o.enemies do
			if o.enemies[i].y > o.parent.player.y then
				o.enemies[i].draw(x, y, r, sw, sh, ...)
			end
		end
	end

	o.newEnemy = function(type, x, y)
		local e = love.game.newEnemy(o, type, x, y)
		e.health = o.enemyTypes[type].health
		e.maxHealth = o.enemyTypes[type].health
		e.strength = o.enemyTypes[type].strength
		e.luck = o.enemyTypes[type].luck
		e.speed = o.enemyTypes[type].speed
		e.drop = o.enemyTypes[type].drop

		o.enemies[#o.enemies + 1] = e

		return o.enemies[#o.enemies]
	end

	o.deleteEnemy = function(x, y)
		for i = 1, #o.enemies do
			local e = o.enemies[i]

			if math.length(e.x, e.y, x, y) < 16 then
				table.remove(o.enemies, i)
				break
			end
		end
	end

	o.attackEnemy = function(x, y, damage)
		local atkEnemy = nil

		for i = 1, #o.enemies do
			local e = o.enemies[i]

			if e and not e.death then
				if e.attacked <= 0 and math.length(e.x, e.y, x, y) < 16 then
					e.attacked = 0.2
					e.health = e.health - damage
					if e.health <= 0 then
						e.death = true
						local r = math.random(e.drop, 20)
						if r < 15 and r % 5 == 0 then
							o.parent.itemManager.newItem(1, e.x + math.random(-2, 2), e.y + math.random(-2, 2))
						end
						if r == 17 then
							o.parent.itemManager.newItem(2, e.x + math.random(-2, 2), e.y + math.random(-2, 2))
						end
						if r == 18 then
							o.parent.itemManager.newItem(3, e.x + math.random(-2, 2), e.y + math.random(-2, 2))
						end
						if r == 19 then
							o.parent.itemManager.newItem(4, e.x + math.random(-2, 2), e.y + math.random(-2, 2))
						end
						if r == 20 then
							o.parent.itemManager.newItem(5, e.x + math.random(-2, 2), e.y + math.random(-2, 2))
						end
					end

					atkEnemy = e
				end
			end
		end

		return atkEnemy
	end

	o.getEnemyCount = function()
		return #o.enemies
	end

	o.getEnemyLivingCount = function()
		local cnt = 0

		for i = 1, #o.enemies do
			if not o.enemies[i].death then
				cnt = cnt + 1
			end
		end

		return cnt
	end

	o.getEnemyKillCount = function()
		local cnt = 0

		for i = 1, #o.enemies do
			if o.enemies[i].death then
				cnt = cnt + 1
			end
		end

		return cnt
	end

	return o
end