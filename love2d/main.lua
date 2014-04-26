require "game"

function love.load()
	G = love.graphics
	W = love.window
	S = love.sound
	FS = love.filesystem

	FONT_SMALL = G.newFont(12)
	FONT_NORMAL = G.newFont(16)
	FONT_BIG = G.newFont(24)
	G.setFont(FONT_NORMAL)

	ludGame = love.game.newGame()
	ludGame.setVersion("0.0.1")
	ludGame.init()
end

function love.update(dt)
	ludGame.update(dt)
end

function love.draw()
	love.window.setTitle("[LD29]Game (FPS:" .. love.timer.getFPS() .. ")")
	ludGame.draw()
end

function love.keypressed(key, code)

end

function love.mousepressed(x, y, key)

end

function love.mousereleased(x, y, key)

end