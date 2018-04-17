
scores = {}

lg = love.graphics

function scores.enter()
	state = STATE_SCORE
	bgScene = love.graphics.newImage("img/background.png")
end

function scores.draw()
	
	local sw = love.graphics.getWidth()/ bgScene:getWidth()
	local sh = love.graphics.getHeight()/ bgScene:getHeight()
	lg.draw(bgScene, lg.getWidth() / 2 - bgScene:getWidth() / 2 * sw, lg.getHeight() / 2 - bgScene:getHeight() / 2 * sh, 0, sw, sh)
	count = 0
	for i, score, name in highscore() do
		count = count + 1
		lg.print(count, 150, i * 35)
		lg.print(name .. "       ", (lg.getWidth() / 2) - 105, i * 35)
		lg.print(score, 550, i * 35)
	end

	lg.setColor(255,255,0)
	lg.print("EXIT", (lg.getWidth() /2) - 35, (lg.getHeight() /2) + 185)
	lg.setColor(255,255,255)

end

function comp(w1, w2)
	if w1 < w2 then
		return true
	end
end

function scores.update(dt)

end

function scores.keypressed(k, uni)
	if k == "return" then
		menu.enter()
	end
end