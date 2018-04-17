cow = {}
cow.__index = cow

function cow.create(x, y, speed)
	local self = setmetatable({}, cow)
	self.x = x
	self.y = y
	self.offScreen = false
	self.dying = false
	self.dead = false
	self.dead_remove = false
	self.dead_time = 0.5
	self.speed = speed
	--self.img = love.graphics.newImage("img/cow1.png")
	self.animSpeed = 0.2
	self.deathAnimSpeed = 0.3
	self.level = 1
	self.img1_graze = love.graphics.newImage("img/cow1-graze.png")
	self.img2_graze = love.graphics.newImage("img/cow2-graze.png")
	self.img3_graze = love.graphics.newImage("img/cow3-graze.png")
	--self.anim1 = newAnimation(self.img1, 50, 50, 
	self.graze_anim1 = newAnimation(self.img1_graze, 200, 200, self.animSpeed, 7)
	self.graze_anim1:setMode("loop")
	self.graze_anim2 = newAnimation(self.img2_graze, 200, 200, self.animSpeed, 7)
	self.graze_anim2:setMode("loop")
	self.graze_anim3 = newAnimation(self.img3_graze, 200, 200, self.animSpeed, 7)
	self.graze_anim3:setMode("loop")
	self.img1_death = love.graphics.newImage("img/cow1-death.png")
	self.img2_death = love.graphics.newImage("img/cow2-death.png")
	self.img3_death = love.graphics.newImage("img/cow3-death.png")
	self.death_anim1 = newAnimation(self.img1_death, 200, 200, self.deathAnimSpeed, 3)
	self.death_anim1:setMode("once")
	self.death_anim2 = newAnimation(self.img2_death, 200, 200, self.deathAnimSpeed, 3)
	self.death_anim2:setMode("once")
	self.death_anim3 = newAnimation(self.img3_death, 200, 200, self.deathAnimSpeed, 3)
	self.death_anim3:setMode("once")
	self.maxDeathFrame = 3
	self.hp = 2
	self.score = 100
	self.hitSound = love.audio.newSource("sound/Cow_Hurt.wav")
	self.hitSound:setVolume(0.5)
	return self
end

function cow:SetLevel(CowLevel)
	self.level = CowLevel
	if self.level == 2 then
		self.hp = 3
		self.score = 200
	elseif self.level == 3 then
		self.hp = 4
		self.score = 300
	end
end

function cow.CheckOffScreen(xPos, image)
	if (xPos + image:getWidth()) < 0 then
		return true
	else
		return false
	end
end

function cow:update(dt)
	self.x = self.x - self.speed * dt
--	if (self.x + self.img:getWidth()) < 0 then
--		self.offScreen = true
--	end
	if self.level == 1 then
		if self.dying then
			self.offScreen = cow.CheckOffScreen(self.x, self.img1_death)
			if self.death_anim1:getCurrentFrame() == self.maxDeathFrame then
				self.dying = false
				self.dead = true
			else
				self.death_anim1:update(dt)
			end
		elseif self.dead then
			self.offScreen = cow.CheckOffScreen(self.x, self.img1_death)
			self:DeadUpdate(dt)
			--cow.DeadCountUpdate(self.dead_time, self.dead_remove, dt)
		else
			self.offScreen = cow.CheckOffScreen(self.x, self.img1_graze)
			self.graze_anim1:update(dt)
		end
	elseif self.level == 2 then
		if self.dying then
			self.offScreen = cow.CheckOffScreen(self.x, self.img2_death)
			if self.death_anim2:getCurrentFrame() == self.maxDeathFrame then
				self.dying = false
				self.dead = true			
			else
				self.death_anim2:update(dt)
			end
		elseif self.dead then
			self.offScreen = cow.CheckOffScreen(self.x, self.img2_death)
			self:DeadUpdate(dt)
			--cow.DeadCountUpdate(self.dead_time, self.dead_remove, dt)
		else
			self.offScreen = cow.CheckOffScreen(self.x, self.img2_graze)
			self.graze_anim2:update(dt)
		end
	elseif self.level == 3 then
		if self.dying then
			self.offScreen = cow.CheckOffScreen(self.x, self.img3_death)
			if self.death_anim3:getCurrentFrame() == self.maxDeathFrame then
				self.dying = false
				self.dead = true
			else
				self.death_anim3:update(dt)
			end
		elseif self.dead then
			self.offScreen = cow.CheckOffScreen(self.x, self.img3_death)
			self:DeadUpdate(dt)
			--cow.DeadCountUpdate(self.dead_time, self.dead_remove, dt)
		else
			self.offScreen = cow.CheckOffScreen(self.x, self.img3_graze)
			self.graze_anim3:update(dt)
		end
	end
end

function cow:DeadUpdate(dt)
	--print("cow dead_time" .. self.dead_time)
	--if self.dead_time and self.dead_time > 0 then
	if self.dead_time > 0 then
		self.dead_time = self.dead_time - dt
	else
		self.dead_time = 0
		self.dead_remove = true
	end
end

--function cow.DeadCountUpdate(deadTime, deadRemove, dt)
--	print("Dead update" .. deadTime .. " " .. deadRemove)
--	if deadTime > 0 then
--		deadTime = deadTime - dt
--	else
--		deadTime = 0
--		deadRemove = true
--	end
--end

function cow:draw()
	--love.graphics.draw(self.img, self.x, self.y)
	if self.level == 1 then
		if self.dying or self.dead then
			self.death_anim1:draw(self.x, self.y)
		else
			self.graze_anim1:draw(self.x, self.y)
		end
	elseif self.level == 2 then
		if self.dying or self.dead  then
			self.death_anim2:draw(self.x, self.y)
		else
			self.graze_anim2:draw(self.x, self.y)
		end
	elseif self.level == 3 then
		if self.dying or self.dead  then
			self.death_anim3:draw(self.x, self.y)
		else
			self.graze_anim3:draw(self.x, self.y)
		end
	end
end

function cow:getBBox()
	if self.dying or self.dead then
		return {x = 0, y = 0, w = 0, h = 0}
	else
		return {x = self.x + 60, y = self.y + 70, w = 85, h = 115}
	end
	--return {x = self.x+10, y = self.y, w = 115, h = 160}
end

function cow:hit()
	self.hitSound:play()
	self.hp = self.hp - 1
	if self.hp <= 0 then
		self.hp = 0
		self.dying = true
	end
	self.hitSound:rewind()
end

function cow:changeSpeed(newSpeed)
	self.speed = newSpeed
end
