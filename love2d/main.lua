require "lib/TSerial"
require "game"

function love.load()
	G = love.graphics
	W = love.window
	A = love.audio
	S = love.sound
	T = love.timer
	FS = love.filesystem

	G.setDefaultFilter("nearest", "nearest", 0)
	G.setLineStyle("rough")

	FONT_SMALL = G.newFont("font/alagard.ttf", 16)
	FONT_NORMAL = G.newFont("font/alagard.ttf", 24)
	FONT_BIG = G.newFont("font/alagard.ttf", 32)
	FONT_TITLE = G.newFont("font/alagard.ttf", 48)
	FONT_TITLE2 = G.newFont("font/alagard.ttf", 128)
	G.setFont(FONT_NORMAL)

	ludGame = love.game.newGame()
	ludGame.setVersion("0.1.0")
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

math.length = function(x1, y1, x2, y2)
	return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
end