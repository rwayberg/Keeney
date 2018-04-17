
menu = {}

lg = love.graphics


function menu.enter()
	state = STATE_MENU
	font = lg.newFont("fonts/slkscr.ttf", 48)
	menuscene = lg.newImage("img/MainMenuBackGround.png")
	lg.setFont(font)
	selection = 1
end

function menu.draw()
	menu.drawBackground()
	menu.drawMenu()
end

function menu.drawBackground()
	--lg.push()
	
	local sw = love.graphics.getWidth()/ menuscene:getWidth()
	local sh = love.graphics.getHeight()/ menuscene:getHeight()
	lg.draw(menuscene,  lg.getWidth() / 2 - menuscene:getWidth() / 2 * sw, lg.getHeight() / 2 - menuscene:getHeight() / 2 * sh, 0, sw, sh)
	--lg.pop()
end

function menu.drawMenu()
	--lg.push()
	if selection == 1 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print("PLAY GAME", (lg.getWidth() /2) - 160, (lg.getHeight() /2) - 100)
	if selection == 2 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print("HIGH SCORES", (lg.getWidth() /2) - 180, (lg.getHeight() /2) - 30)
	if selection == 3 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print("EXIT", (lg.getWidth() /2) - 65, (lg.getHeight() /2) + 50)
	lg.setColor(255,255,255)
	--lg.pop()
end

function menu.update(dt)

end

function menu.keypressed(k, uni)
	--selectAudio = love.audio.newSource("sound/Blip_Select.wav", "static")
	--selectAudio:setVolume(0.5)
	--enterSound = love.audio.newSource("sound/EnterSelect.wav", "static")
	--enterSound:setVolume(0.5)
	if k == "down" then
		selection = wrap(selection + 1, 1,3)
		selectAudio:play()
		selectAudio:rewind()
	elseif k == "up" then
		selection = wrap(selection - 1, 1,3)
		selectAudio:play()
		selectAudio:rewind()
	elseif k == "return" then
		if selection == 1 then
			enterSound:play()
			enterSound:rewind()
			ingame.enter()
		elseif selection == 2 then
			enterSound:play()
			enterSound:rewind()
			scores.enter()
		elseif selection == 3 then
			--TODO add function in main for closing game
			highscore.save()
			love.event.quit()
		end
	elseif k == "escape" then
		--TODO add function in main for closing game
		highscore.save()
		love.event.quit()
	end
end