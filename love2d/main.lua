require "game"

function love.load()
	G = love.graphics
	W = love.window
	S = love.sound
	T = love.timer
	FS = love.filesystem

	G.setDefaultFilter("nearest", "nearest", 0)
	G.setDefaultFilter("nearest", "nearest", 0)

	FONT_SMALL = G.newFont("font/alagard.ttf", 16)
	FONT_NORMAL = G.newFont("font/alagard.ttf", 24)
	FONT_BIG = G.newFont("font/alagard.ttf", 32)
	FONT_TITLE = G.newFont("font/alagard.ttf", 48)
	FONT_TITLE2 = G.newFont("font/alagard.ttf", 128)
	G.setFont(FONT_NORMAL)

	ludGame = love.game.newGame()
	ludGame.setVersion("0.3.1")
	ludGame.init()
end

function love.update(dt)
	ludGame.update(dt)
end

function love.draw()
	love.window.setTitle("[LD29]Mole Empire (FPS:" .. love.timer.getFPS() .. ")")
	ludGame.draw()
end

function love.keypressed(key, code)
	ludGame.onKeyHit(key, code)
end

function love.mousepressed(x, y, key)
	ludGame.onMouseHit(x, y, key)
end

function love.mousereleased(x, y, key)
	ludGame.onMouseUp(x, y, key)
end