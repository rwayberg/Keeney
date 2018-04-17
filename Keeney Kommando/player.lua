player = {MAX_JUMP = 75, JUMP_SPEED = 250, GRAVITY = 12, MAX_VELOCITY = 300, MAX_STUCK = 3}
player.__index = player

function player.create(x, y, animSpeed)
	local self = setmetatable({}, player)
	self.x = x
	self.y = y
	--self.currentY = y
	self.y_default = y
	self.speed = speed
	--self.img = love.graphics.newImage("img/playerwalk.png")
	self.img = love.graphics.newImage("img/player1-w1-forward.png")
	--self.img = newPaddedImage("img/player1-w1-forward.png")
	--self.img = love.graphics.newImage("img/player1-w1-po2-x4.png")
	self.animSpeed = animSpeed
	self.anim = newAnimation(self.img, 250, 250, self.animSpeed, 8)
	--self.anim = newAnimation(self.img, 128, 128, self.animSpeed, 8)
	self.imgDeath = love.graphics.newImage("img/player1-w1-death.png")
	self.animDeath = newAnimation(self.imgDeath, 250, 250, self.animSpeed, 7)
	self.maxDeathFrame = 7
	self.animDeath:setMode("once")
	self.anim:setMode("loop")
	self.stuck_img = love.graphics.newImage("img/player1-w1-forward-pie.png")
	self.stuck_imgAnim = newAnimation(self.stuck_img, 250, 250, self.animSpeed, 8)
	self.stuck_imgAnim:setMode("loop")
	self.stuck_imgDeath = love.graphics.newImage("img/player1-w1-death-pie.png")
	self.stuck_DeathAnim = newAnimation(self.stuck_imgDeath, 250, 250, self.animSpeed, 7)
	self.stuck_DeathAnim:setMode("once")
	--shadows
	self.imgShadow = love.graphics.newImage("img/player1-w1-forward-shadow.png")
	self.shadowAnim = newAnimation(self.imgShadow, 250, 15, self.animSpeed, 8)
	self.shadowAnim:setMode("loop")
	self.imgDeathShadow = love.graphics.newImage("img/player1-w1-death-shadow.png")
	self.deathShadowAnim = newAnimation(self.imgDeathShadow, 250, 15, self.animSpeed, 8)
	self.deathShadowAnim:setMode("once")
	self.shadowXOffset = self.x
	self.shadowYOffset = 225 + self.y
	--
	--self.jumping = false
	self.state = "walking"
	self.lift = 0.5
	self.liftMax = 0.5
	self.y_velocity = self.MAX_VELOCITY
	self.falling = false
	self.jumping = false
	self.jumpTimeOut = 0
	self.maxJump = self.MAX_JUMP
	self.lifeStart = 3
	self.lifeCount = self.lifeStart 
	maxJumpTimeOut = 17
	self.hitTimeOut = 0
	maxhitTimeOut = 1
	self.score = 0
	self.steakcount = 1
	self.hit = false
	self.death = false
	self.stuck = false
	self.stuckCount = 1
	self.currentGravity = self.GRAVITY
	self.hitSound = love.audio.newSource("sound/Hit_Hurt.wav", "static")
	self.hitSound:setVolume(0.2)
	self.hitGround = love.audio.newSource("sound/HitGround.wav", "static")
	self.hitGround:setVolume(0.2)
	self.onGround = false
	self.jumpSound = love.audio.newSource("sound/Jump.wav", "static")
	self.jumpSound:setVolume(0.2)
	self.pieSound = love.audio.newSource("sound/Hit_Pie.wav")
	self.pieSound:setVolume(0.3)
	return self
end

function player:update(dt)
	if self.jumping then
		if self.stuck then
			self.stuck_imgAnim:seek(3)
			self.shadowAnim:seek(3)
		else
			self.anim:seek(3)
			self.deathShadowAnim:seek(3)
		end
		--print("Jump max " .. self.maxJump .. " current y " .. self.y)
		if self.y < self.maxJump or not love.keyboard.isDown(" ") then
			self.falling = true
		end
--		if not love.keyboard.isDown(" ") or self.y < self.MAX_JUMP then
--			self.falling = true
--		end
		if self.falling then
--			self.y_velocity = self.y_velocity - self.GRAVITY
			self.y_velocity = self.y_velocity - self.currentGravity
		end
		self.y = self.y - self.y_velocity * dt
		if self.y > self.y_default then
			self.y = self.y_default
			self.y_velocity = self.MAX_VELOCITY
			self.jumping = false
			self.falling = false
		end
	else
		if self.hit then
			if self.stuck then
				self.stuck_DeathAnim:update(dt)
			else
				self.animDeath:update(dt)
			end
			self.deathShadowAnim:update(dt)
			if self.animDeath:getCurrentFrame() == self.maxDeathFrame or self.stuck_DeathAnim:getCurrentFrame() == self.maxDeathFrame then
				if not self.onGround then
					self.hitGround:play()
					self.onGround = true
					self.hitGround:rewind()
				end
				if self.lifeCount > 0 then
					if self.hitTimeOut <= 0 then
						if self.stuck then
							self.stuck_DeathAnim:reset()
							self.stuck_DeathAnim:play()
						else
							self.animDeath:reset()
							self.animDeath:play()
						end
						self.deathShadowAnim:reset()
						self.deathShadowAnim:play()
						self.hit = false
						self.onGround = false
					else
						self.hitTimeOut = self.hitTimeOut - dt
					end
				else
					self.death = true
					gameover.enter(self.score, self.steakcount)
				end
			end
		else
			if self.stuck then
				self.stuck_imgAnim:update(dt)
			else
				self.anim:update(dt)
			end
			self.shadowAnim:update(dt)
		end
		if self.jumpTimeOut > 0 then
			self.jumpTimeOut = self.jumpTimeOut - 1
		else
			self.jumpTimeOut = 0
		end
	end
end

function player:draw()
	if self.hit then
		if self.stuck then
			--self.stuck_DeathAnim:seek(self.animDeath:getCurrentFrame())
			self.stuck_DeathAnim:draw(self.x, self.y)
		else
			--self.animDeath:seek(self.stuck_DeathAnim:getCurrentFrame())
			self.animDeath:draw(self.x, self.y)
		end
		self.deathShadowAnim:draw(self.shadowXOffset, self.shadowYOffset)
	else
		if self.stuck then
			--self.stuck_imgAnim:seek(self.anim:getCurrentFrame())
			self.stuck_imgAnim:draw(self.x, self.y)
		else
			--self.anim:seek(self.stuck_imgAnim:getCurrentFrame())
			self.anim:draw(self.x, self.y)
		end
		self.shadowAnim:draw(self.shadowXOffset, self.shadowYOffset)
	end
end

function player:getBBox()
	--return {x = self.x+90, y = self.y+110, w = 120, h = 110}
	return {x = self.x+75, y = self.y+100, w = 120, h = 110}
end

function player:setStuck()
	self.pieSound:play()
	self.stuck = true
	--self.currentGravity = 2
	self.currentGravity = self.GRAVITY * 2
	self.stuckCount = 0
	self.maxJump = 175
	self.pieSound:rewind()
end

function player:jump()
	--if self.state == "walking" then 
	--	--print("set jumping")
	--	self.state = "jumping"
	--	self.y_velocity = self.velocity
	--end
	if self.stuck then
		print("Player is stuck  : count " .. self.stuckCount)
		if self.jumpTimeOut == 0 then
			if self.stuckCount < self.MAX_STUCK then
				--self.maxJump = 175
				--self.currentGravity = 2
				self.stuckCount = self.stuckCount + 1
			else
				self.stuckCount = 0
				self.stuck = false
				self.maxJump = self.MAX_JUMP
				self.currentGravity = self.GRAVITY
			end
			
		end
	end
	if not self.jumping and self.jumpTimeOut == 0 then
		self.jumpSound:play()
		self.jumping = true
		self.jumpTimeOut = maxJumpTimeOut
		self.jumpSound:rewind()
	end
end

function player:collide()
	print("Player hit a cow!")
	self.hitSound:play()
	self.hit = true
	self.hitTimeOut = maxhitTimeOut
	self.hitSound:rewind()
end



