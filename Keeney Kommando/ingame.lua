
ingame = {}

lg = love.graphics

function ingame.enter()
	--Remember that if you make a variable to not name if the same of other files
	state = STATE_INGAME
	movetime = 0
	transtime = 0
	cloudTimer = 0
	cloudSpawnTime = 8
	birdTimer = 0
	birdSpawnTime = 25
	scene = lg.newImage("img/background.png")
	scene2 = lg.newImage("img/background.png")
	--player = lg.newImage("img/player/playerwalk.png")
	cowTimer = 0
	cowSpawnTime = 5
	bgX = 0
	bgY = 0
	--playerSpeed = 0.2
	--animPlayer = newAnimation(player, 250, 250, playerSpeed, 8)
	--animPlayer:setMode("loop")
	bgSpeed_Default = 210
	bgSpeed = 210
	--Might want to create an object table and add a cloud table to it
	--could add a table for the background and move the bg stuff to a new file
	cloudList = {}
	--table.insert(cloudList, cloud.create(15, 20, 2))
	
	--local rand = math.random(5,10)
	--ingame.createClouds(rand)
	ingame.createFirstClouds()
	birdList = {}
	ingame.createBirds(1)
	cowList = {}
	local cowSpawning = false
	player1 = player.create(50, 175, 0.2)
	bulletList = {}
	bulletX = 230
	bulletY = 321
	bulletYOffset = 20
	maxBullets = 5
	ingameHUD = hud.create()
	ingameHUD.lifeCount = player1.lifeStart
	local paused = false
	pauseImg = lg.newImage("img/pause.png")
	pauseSelection = 1
	maxCowSpawnCount = 10
	currentCowSpawnCount = 0
	currentCowSpawnLevel = 1
	maxCowSpawnLevel = 3
	steakList = {}
	steakY = 365
	pieList = {}
	pieTimer = 0
	pieSpawnTime = 2
	coffeeList = {}
	coffeeSpawnTime = 2
	coffeeTimer = 0
	coffeeSpeedUp = 200
	speedUpInEffect = false
	coffeeEffectTimeMax = 8
	coffeeEffectCurrentTime = 0
	shotSound = love.audio.newSource("sound/Shoot2.wav", "static")
	shotSound:setVolume(0.3)
	bigBirdList = {}
	bigBirdSpawnTime = 5
	bigBirdTimer = 0
	bigBirdActive = false
	playerBBoxActive = true
	collectSound = love.audio.newSource("sound/Pickup_Coin2.wav")
	collectSound:setVolume(1.5) 
	speedUpSound = love.audio.newSource("sound/SpeedUp.wav")
	speedUpSound:setVolume(0.8)
end

function ingame.createFirstClouds()
	local rand = math.random(2, 4)
	for count = 1, rand do
		local randSpeed = math.random(20,50)
		local randX = math.random(0, lg.getWidth())
		local randY = math.random(10, 80)
		table.insert(cloudList, cloud.create(randX, randY, randSpeed))
	end
end

function ingame.createClouds(number)
	--local rand = math.random(5,10)
	
	for count = 1, number do
		local randSpeed = math.random(20, 50)
		local randY = math.random(40, 80)
		table.insert(cloudList, cloud.create(lg.getWidth(), randY, randSpeed))
	end
end

function ingame.createBirds(number)
	for bc = 1, number do
		local randSpeed = math.random(30, 60)
		local randY = math.random(40, 80)
		table.insert(birdList, bird.create(0, randY, randSpeed))
	end
end

function ingame.createCows(number)
	for cc = 1, number do
		currentCowSpawnCount = currentCowSpawnCount + 1
		local newCow = cow.create(lg.getWidth(), 220, bgSpeed)
		if currentCowSpawnLevel < maxCowSpawnLevel and currentCowSpawnCount >= maxCowSpawnCount then
			currentCowSpawnCount = 0
			currentCowSpawnLevel = currentCowSpawnLevel + 1
		end
		newCow:SetLevel(currentCowSpawnLevel)
		table.insert(cowList, newCow)
		--table.insert(cowList, cow.create(lg.getWidth(), 220, bgSpeed))
	end
end

function ingame.createBullet(number)
	for bc = 1, number do
		--local proX =
		shotSound:play()
		local proY = (player1.y + (player1.img:getHeight() / 2)) + bulletYOffset
		--table.insert(bulletList, bullet.create(bulletX, bulletY))
		table.insert(bulletList, bullet.create(bulletX, proY))
		shotSound:rewind()
	end
end

function ingame.createSteak(posX)
	table.insert(steakList, steak.create(posX, steakY, bgSpeed))
end

function ingame.createPie()
	local newpie = pie.create(lg.getWidth(), 380, bgSpeed)
	local newBox = newpie:getBBox()
	local pieX = lg.getWidth()
	--print("x ".. newBox.x .. " y " .. newBox.y .. " w " .. newBox.w ..  " h " .. newBox.h) --
	--check all steaks
	--for steakNumber=#steakList,1,-1 do
	--	local steakBB = steakList[steakNumber]:getBBox()
	--	if CheckCollision(pieX, newpie.y, newpie.w, newpie.h, steakBB.x, steakBB.y, steakBB.w, steakBB.h) then
	--		pieX = pieX + steakBB.w + 5
	--	end
	--end
	--check all coffee
	for cofNum=#coffeeList,1,-1 do
		local cofBB = coffeeList[cofNum]:getBBox()
		if CheckCollision(pieX, newBox.y, newBox.w, newBox.h, cofBB.x, cofBB.y, cofBB.w, cofBB.h) then
			pieX = pieX + cofBB.w + 25
			print("pie over coffee moved to " .. pieX)
		end
	end
	--check all cows
	for cowNum=#cowList,1,-1 do
		local cowBB = cowList[cowNum]:getBBox()
		if CheckCollision(pieX, newBox.y, newBox.w, newBox.h, cowBB.x, cowBB.y, cowBB.w, cowBB.h) then
			pieX = pieX + cowBB.w + 20
			print("pie over cow moved to " .. pieX)
		end
	end
	table.insert(pieList, pie.create(pieX, 380, bgSpeed))
	--table.insert(pieList, pie.create(pieX, 380, bgSpeed))
end

function ingame.createCoffee()
	if not speedUpInEffect then
		local newCoffee = coffee.create(lg.getWidth(), 350, bgSpeed)
		local newCofBox = newCoffee:getBBox()
		local cofX = lg.getWidth()
		for cowNum=#cowList,1,-1 do
			local cowBB = cowList[cowNum]:getBBox()
			if CheckCollision(cofX, newCofBox.y, newCofBox.w, newCofBox.h, cowBB.x, cowBB.y, cowBB.w, cowBB.h) then
				cofX = cofX + cowBB.w + 20
				print("coffee over cow moved to " .. cofX)
			end
		end
		for pieNum=#pieList,1,-1 do
			local pieBB = pieList[pieNum]:getBBox()
			if CheckCollision(cofX, newCofBox.y, newCofBox.w, newCofBox.h, pieBB.x, pieBB.y, pieBB.w, pieBB.h) then
				cofX = cofX + pieBB.w + 20
				print("coffee over pie moved to " .. cofX)
			end
		end
		table.insert(coffeeList, coffee.create(cofX, 350, bgSpeed))
		--table.insert(coffeeList, coffee.create(lg.getWidth(), 350, bgSpeed))
	--else
	--	print("Cannot create coffee")
	end
end

function ingame.createBigBird()
	--if not bigBirdActive then
	--end
	if not bigBirdActive then
		table.insert(bigBirdList, bigbird.create(lg.getWidth(), 100, bgSpeed))
	else
		print("big bird active")
	end
end

function ingame.draw()
	
	ingame.drawBackground()
	ingame.drawClouds()
	ingame.drawBirds()
	ingame.drawBigBird()
	ingame.drawCows()
	ingame.drawBullets()
	ingame.drawSteaks()
	ingame.drawPies()
	player1:draw()
	ingameHUD:draw()
	ingame.drawCoffee()
	if paused then
		--lg.draw(pauseImg, lg.getWidth() / 2, lg.getHeight() / 2)
		lg.draw(pauseImg, 0, 0)
		lg.print("Paused", (lg.getWidth() / 2) - 60, (lg.getHeight() / 2) - 60)
		if pauseSelection == 1 then
			lg.setColor(255,255,0)
		else
			lg.setColor(255,255,255)
		end
		lg.print("Resume", (lg.getWidth() / 2) - 60, (lg.getHeight() / 2) - 10)
		if pauseSelection == 2 then
			lg.setColor(255,255,0)
		else
			lg.setColor(255,255,255)
		end
		lg.print("Exit", (lg.getWidth() / 2) - 20, (lg.getHeight() / 2) + 20)
		lg.setColor(255,255,255)
	end
--	ingame.drawPlayer()
end

function ingame.drawBackground()
	lg.push()
	
	local sw = lg.getWidth()/ scene:getWidth()
	local sh = lg.getHeight()/ scene:getHeight()
	local x = lg.getWidth() / 2 - scene:getWidth() / 2 * sw
	local y = lg.getHeight() / 2 - scene:getHeight() / 2 * sh
	
	if x + bgX > lg.getWidth() then
		bgX = 0
	end
	lg.draw(scene, x - bgX, y - bgY, 0, sw, sh)
	
	local s2xOffset = scene:getWidth()
	local s1X = x + scene:getWidth() * sw
	lg.draw(scene2, s1X - bgX, y, 0, sw, sh) 
	lg.pop()
end

function ingame.drawClouds()
	for dc=1,#cloudList,1 do
		lg.push()
		cloudList[dc]:draw()
		lg.pop()
	end
end

function ingame.drawBirds()
	for i=1,#birdList,1 do
		birdList[i]:draw()
	end
end

function ingame.drawCows()
	for i=1,#cowList,1 do
		cowList[i]:draw()
	end
end

function ingame.drawBullets()
	for i=1,#bulletList,1 do
		bulletList[i]:draw()
	end
end

function ingame.drawSteaks()
	for i=1,#steakList,1 do
		steakList[i]:draw()
	end
end

function ingame.drawPies()
	for i=1,#pieList,1 do
		pieList[i]:draw()
	end
end

function ingame.drawCoffee()
	for i=1,#coffeeList,1 do
		coffeeList[i]:draw()
	end
end

function ingame.drawBigBird()
	for i=1,#bigBirdList,1 do
		bigBirdList[i]:draw()
	end
end

function ingame.moveBackground(dt)
	bgX = bgX + (bgSpeed * dt)
end

function ingame.updateclouds(dt)
		--update or remove clouds
		for i=#cloudList,1,-1 do
			if cloudList[i].offScreen == true then
				table.remove(cloudList, i)
			end
		end
		--add new clouds
		cloudTimer = cloudTimer + dt
		local cSpawnRand = math.random(0, 10)
		if #cloudList < 10 and cloudTimer >= cloudSpawnTime and cSpawnRand == 4 then
			ingame.createClouds(1)
			cloudTimer = 0
		end
		for c=1,#cloudList,1 do
			cloudList[c]:update(dt)
		end
end

function ingame.updatebirds(dt)
--bird update and remove
		birdTimer = birdTimer + dt
		if #birdList < 2 and cSpawnRand == 5 and birdTimer >= birdSpawnTime then
			ingame.createBirds(1)
			birdTimer = 0
		end

		for b=#birdList,1,-1 do
			if birdList[b].offScreen == true then
				table.remove(birdList, b)
			else
				birdList[b]:update(dt)
			end
		end
end

function ingame.updatecows(dt)
--cow update and remove
		cowTimer = cowTimer + dt
		if cowTimer >= cowSpawnTime then
			ingame.createCows(1)
			cowTimer = 0
			if cowSpawnTime > 1 then
				cowSpawnTime = cowSpawnTime - 0.2
			else
				cowSpawnTime = 1
			end
		end

		if #cowList > 0 then
			for cl=#cowList,1,-1 do
				if cowList[cl].dead_remove == true then 
					local randNum = math.random(1, 2)
					--print("steak " .. randNum)
					if randNum == 1 then
						--print("create steak at " .. cowList[cl].x)
						ingame.createSteak(cowList[cl].x + 75)
					end
					table.remove(cowList, cl)
				elseif cowList[cl].offScreen == true then
					table.remove(cowList, cl)
				else
					cowList[cl]:update(dt)
				end
			end
		end
end

function ingame.updatebullets(dt)
--Update bullets
		for bulletNumber=#bulletList,1,-1 do
			if bulletList[bulletNumber].offScreen == true then
				table.remove(bulletList, bulletNumber)
			else
				bulletList[bulletNumber]:update(dt)
			end
		end

		--Check bullet collisions
		for bulletNumber=#bulletList,1,-1 do
			local bulletBox = bulletList[bulletNumber]:getBBox()
			for cowNumber=#cowList,1,-1 do
				local cowBox = cowList[cowNumber]:getBBox()
				if CheckCollision(bulletBox.x, bulletBox.y, bulletBox.w, bulletBox.h, cowBox.x, cowBox.y, cowBox.w, cowBox.h) then
					cowList[cowNumber]:hit()
					if cowList[cowNumber].hp == 0 then
						ingameHUD:addScore(cowList[cowNumber].score)
					end
					bulletList[bulletNumber].offScreen = true
				end	
			end
			for bigNum=#bigBirdList,1,-1 do
				local bigBox = bigBirdList[bigNum]:getBBox()
				if CheckCollision(bulletBox.x, bulletBox.y, bulletBox.w, bulletBox.h, bigBox.x, bigBox.y, bigBox.w, bigBox.h) then
					bigBirdList[bigNum]:hit()
					ingameHUD:addScore(bigBirdList[bigNum].score)
					bulletList[bulletNumber].offScreen = true
				end
			end
		end
end

function ingame.updatesteaks(dt)
	for steakNumber=#steakList,1,-1 do
		if steakList[steakNumber].offScreen == true then
			--print("remove steak " .. steakNumber)
			table.remove(steakList, steakNumber)
		else
			--print("update steak #" .. steakNumber)
			steakList[steakNumber]:update(dt)
		end
	end
end

function ingame.updatepies(dt)
	pieTimer = pieTimer + dt
	if pieTimer >= pieSpawnTime then
		local pieRand = math.random(0, 4)
		if pieRand == 1 then
			ingame.createPie()
		end
		pieTimer = 0
	end
	
	for pieNumber=#pieList,1,-1 do
		if pieList[pieNumber].offScreen == true then
			table.remove(pieList, pieNumber)
		else
			pieList[pieNumber]:update(dt)
		end
	end
end

function ingame.updatecoffee(dt)
	coffeeTimer = coffeeTimer + dt
	if coffeeTimer >= coffeeSpawnTime then
		local cfeRand = math.random(0,2)
		if cfeRand == 1 then
			ingame.createCoffee()
		end
		coffeeTimer = 0
	end
	
	for coffeeNumber=#coffeeList,1,-1 do
		if coffeeList[coffeeNumber].offScreen == true then
			table.remove(coffeeList, coffeeNumber)
		else
			coffeeList[coffeeNumber]:update(dt)
		end
	end
	
	if speedUpInEffect == true then
		coffeeEffectCurrentTime = coffeeEffectCurrentTime + dt
		if coffeeEffectCurrentTime >= coffeeEffectTimeMax then
			coffeeEffectCurrentTime = 0
			speedUpInEffect = false
			ingame.changeSpeed(bgSpeed_Default)
		end
	end
end

function ingame.updateBigBird(dt)
	bigBirdTimer = bigBirdTimer + dt
	local bbRand = math.random(0, 6)
	--print("big bird timer " .. bigBirdTimer)
	if (bigBirdTimer >= bigBirdSpawnTime and bbRand == 1) or bigBirdTimer == (bigBirdSpawnTime * 2) then
		ingame.createBigBird()
		bigBirdTimer = 0
	end
	for bigBNum=#bigBirdList,1,-1 do
		if bigBirdList[bigBNum].offScreen == true then
			print("big bird offscreen")
			table.remove(bigBirdList, bigBNum)
		else
			bigBirdList[bigBNum]:update(dt)
		end
	end
end

function ingame.changeSpeed(newSpeed)
	bgSpeed = newSpeed
	--print("bgSpeed " .. bgSpeed)
	
	for cowNum=#cowList,1,-1 do
		cowList[cowNum]:changeSpeed(bgSpeed)
	end
	
	for coffeeNum=#coffeeList,1,-1 do
		coffeeList[coffeeNum]:changeSpeed(bgSpeed)
	end
	
	for pieNum=#pieList,1,-1 do
		pieList[pieNum]:changeSpeed(bgSpeed)
	end
	
	for steakNum=#steakList,1,-1 do
		steakList[steakNum]:changeSpeed(bgSpeed)
	end
end

function ingame.updateplayer(dt)
if playerBBoxActive then
	local pBB = player1:getBBox()
	
	for cofBBNum=#coffeeList,1,-1 do
		local cofBB=coffeeList[cofBBNum]:getBBox()
		if CheckCollision(pBB.x, pBB.y, pBB.w, pBB.h, cofBB.x, cofBB.y, cofBB.w, cofBB.h) then
			print("Player got coffee")
			speedUpSound:play()
			coffeeList[cofBBNum].offScreen = true
			table.remove(coffeeList, cofBBNum)
			if not speedUpInEffect then
				speedUpInEffect = true
				--print("bgSpeed " .. bgSpeed)
				ingame.changeSpeed(bgSpeed + coffeeSpeedUp)
				--set the speed
				speedUpSound:rewind()
			end
		end
	end
	
	for pieBB=#pieList,1,-1 do
		local pBBox = pieList[pieBB]:getBBox()
		if CheckCollision(pBB.x, pBB.y, pBB.w, pBB.h, pBBox.x, pBBox.y, pBBox.w, pBBox.h) then
			print("Player hit pie")
			pieList[pieBB].offScreen = true
			table.remove(pieList, pieBB)
			player1:setStuck()
		end
	end
	
	for steakBB=#steakList,1,-1 do
		local sBB = steakList[steakBB]:getBBox()
		if CheckCollision(pBB.x, pBB.y, pBB.w, pBB.h, sBB.x, sBB.y, sBB.w, sBB.h) then
			--print("steak pickup")
			collectSound:play()
			steakList[steakBB].offscreen = true
			table.remove(steakList, steakBB)
			ingameHUD:addSteak(1)
			collectSound:rewind()
		end
	end
	--bigbird hit
	for bigNum=#bigBirdList,1,-1 do
		local bigBB = bigBirdList[bigNum]:getBBox()
		if CheckCollision(pBB.x, pBB.y, pBB.w, pBB.h, bigBB.x, bigBB.y, bigBB.w, bigBB.h) then
			ingameHUD:removeLife(1)
			player1.lifeCount = ingameHUD.lifeCount
			player1.score = ingameHUD.score
			player1.steakcount = ingameHUD.steakCount
			bigBirdList[bigNum].offScreen = true
			player1:collide()
			ingame.changeSpeed(bgSpeed_Default)
			for b in pairs(bulletList) do
				bulletList[b] = nil
			end
		end
	end
--Check player collisions ax1,ay1,aw,ah, bx1,by1,bw,bh
	for cowBB=#cowList,1,-1 do
		local cBB = cowList[cowBB]:getBBox() 
		--player death
		if CheckCollision(pBB.x, pBB.y, pBB.w, pBB.h, cBB.x, cBB.y, cBB.w, cBB.h) then
			ingameHUD:removeLife(1)
			player1.lifeCount = ingameHUD.lifeCount
			player1.score = ingameHUD.score
			player1.steakcount = ingameHUD.steakCount
			cowList[cowBB].offScreen = true
			--reset cow spawning
			if(currentCowSpawnLevel > 1) then
				currentCowSpawnLevel = currentCowSpawnLevel - 1
			end
			currentCowSpawnCount = 0
			cowSpawnTime = cowSpawnTime + 0.4
			--print("Player hit a cow!")
			player1:collide()
			--reset coffee
			ingame.changeSpeed(bgSpeed_Default)
			for b in pairs(bulletList) do
				bulletList[b] = nil
			end
		end
	end
end
end

function ingame.update(dt)
	if not paused then
		ingame.moveBackground(dt)
		player1:update(dt)
		--stop because player was hit
		ingame.updateclouds(dt)
		ingame.updatebirds(dt)
		if player1.hit then
			bgSpeed = 0
		else
			if bgSpeed == 0 then
				--print("stopped")
				if player1.lifeCount > 0 then
					bgSpeed = bgSpeed_Default
				end
			end
			ingame.updatecows(dt)
			ingame.updatebullets(dt)
			ingame.updatesteaks(dt)
			ingame.updatecoffee(dt)
			ingame.updatepies(dt)
			ingame.updateBigBird(dt)
			ingame.updateplayer(dt)
		end
	else
		--paused 
	end
end

function ingame.keypressed(k, uni)
	--print("Pressed " .. k)
	if not paused then
		if k == "rctrl" or k == "lctrl" then
			if not player1.hit and #bulletList <= maxBullets then
				ingame.createBullet(1)
			end
		elseif k == " " then
			if not player1.hit and not player1.death then
				player1:jump()
			end
		elseif k == "escape" then
			if paused then
				paused = false
			else
				paused = true
			end
		end
	else
		if k == "up" then
			pauseSelection = wrap(pauseSelection - 1, 1,2)
		elseif k == "down" then
			pauseSelection = wrap(pauseSelection + 1, 1,2)
		elseif k == "return" then
		--1 = resume, 2 == exit
			if pauseSelection == 1 then
				paused = false
			elseif pauseSelection == 2 then
				paused = false
				menu.enter()
			end
		end
		--print("pause menu " .. pauseSelection)
	end
end

