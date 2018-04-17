
gameover = {}

lg = love.graphics

function gameover.enter(score, steakcount)
	bgScene = love.graphics.newImage("img/background.png")
	pauseScene = love.graphics.newImage("img/pause.png")
	steakImg = love.graphics.newImage("img/steak.png")
	state = GAME_OVER
	font = lg.newFont("fonts/slkscr.ttf", 48)
	lg.setFont(font)
	selection = 1
	characterArray = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	char1 = characterArray
	char2 = characterArray
	char3 = characterArray
	char1Pos = 1
	char2Pos = 1
	char3Pos = 1
	totalScore = score
	if totalScore == nil then
		totalScore = 0
	end
	totalSteak = steakcount
	if totalSteak == nil then
		totalSteak = 0
	end
	addScore = 0
	--selectAudio = love.audio.newSource("sound/Blip_Select.wav", "static")
	--selectAudio:setVolume(0.5)
end

function gameover.draw()
	gameover.drawBackground()
end

function gameover.drawBackground()
	
	local sw = love.graphics.getWidth()/ bgScene:getWidth()
	local sh = love.graphics.getHeight()/ bgScene:getHeight()
	lg.draw(bgScene, lg.getWidth() / 2 - bgScene:getWidth() / 2 * sw, lg.getHeight() / 2 - bgScene:getHeight() / 2 * sh, 0, sw, sh)
	lg.draw(pauseScene, 0, 0)
	
	--game over
	lg.print("GAME OVER", (lg.getWidth() /2) - 300, (lg.getHeight() /2) - 240, 0, 2, 2)
	--score
	--totalScore = 1000
	--totalSteak = 10
	lg.print("SCORE", (lg.getWidth() / 2) - 180, (lg.getHeight() / 2) - 150)
	lg.print(totalScore, (lg.getWidth() /2) + 40, (lg.getHeight() /2) - 150)
	lg.draw(steakImg, (lg.getWidth() /2) - 180, (lg.getHeight() /2) - 80, 0, 1, 1)
	lg.print(" X ", (lg.getWidth() /2) - 100, (lg.getHeight() /2) - 80)
	lg.print(totalSteak, (lg.getWidth() /2) + 40, (lg.getHeight() /2) - 80)
	--lg.print("---", (lg.getWidth() /2) - 35, (lg.getHeight() /2) - 45)
	addScore = totalScore + (50 * totalSteak)
	lg.print("TOTAL", (lg.getWidth() /2) - 180, (lg.getHeight() /2) - 15)
	lg.print(addScore, (lg.getWidth() /2) + 40, (lg.getHeight() /2) - 15)
	
	--initials input
	if selection == 1 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print(char1[char1Pos], (lg.getWidth() /2) - 90, (lg.getHeight() /2) + 40, 0, 1.5, 1.5)
	lg.print("_", (lg.getWidth() /2) - 90, (lg.getHeight() /2) + 55, 0, 1.5, 1.5)
	if selection == 2 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print(char2[char2Pos], (lg.getWidth() /2) - 10, (lg.getHeight() /2) + 40, 0, 1.5, 1.5)
	lg.print("_", (lg.getWidth() /2) - 10, (lg.getHeight() /2) + 55, 0, 1.5, 1.5)
	if selection == 3 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print(char3[char3Pos], (lg.getWidth() /2) + 70, (lg.getHeight() /2) + 40, 0, 1.5, 1.5)
	lg.print("_", (lg.getWidth() /2) + 70, (lg.getHeight() /2) + 55, 0, 1.5, 1.5)
	if selection == 4 then
		lg.setColor(255,255,0)
	else
		lg.setColor(255,255,255)
	end
	lg.print("EXIT", (lg.getWidth() /2) - 35, (lg.getHeight() /2) + 150)
	lg.setColor(255,255,255)
	
end

function gameover.update(dt)

end

function gameover.keypressed(k, uni)
	if k == "right" then
		selectAudio:play()
		selection = wrap(selection + 1, 1,4)
		selectAudio:rewind()
	elseif k == "left" then
		selectAudio:play()
		selection = wrap(selection - 1, 1,4)
		selectAudio:rewind()
	elseif k == "up" then
		selectAudio:play()
		if selection == 1 then
			char1Pos = wrap(char1Pos - 1, 1,36)
		elseif selection == 2 then
			char2Pos = wrap(char2Pos - 1, 1,36)
		elseif selection == 3 then
			char3Pos = wrap(char3Pos - 1, 1,36)
		end
		selectAudio:rewind()
	elseif k == "down" then
		selectAudio:play()
		if selection == 1 then
			char1Pos = wrap(char1Pos + 1, 1,36)
		elseif selection == 2 then
			char2Pos = wrap(char2Pos + 1, 1,36)
		elseif selection == 3 then
			char3Pos = wrap(char3Pos + 1, 1,36)
		end
		selectAudio:rewind()
	elseif k == "return" then
		if selection == 4 then
			enterSound:play()
			--save to file
			--highscore.add(char1[char1Pos] .. char2[char2Pos] .. char3[char3Pos], totalScore)
			highscore.add(char1[char1Pos] .. char2[char2Pos] .. char3[char3Pos], addScore)
			highscore.save()
			enterSound:rewind()
			menu.enter()
		end
	--elseif k == "escape" then
	--	menu.enter()
	end
end

function gameover.savescore(name, score)
	
end


