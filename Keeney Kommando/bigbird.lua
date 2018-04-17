bigbird = {}
bigbird.__index = bigbird
local lg = love.graphics

function bigbird.create(x, y, speed)
	local self = setmetatable({}, bigbird)
	self.x = x
	self.y = y
	self.speedBoost = 200
	self.speed = speed + self.speedBoost
	--self.img = lg.newImage("img/birdDive.png")
	self.img = lg.newImage("img/birdDive-x4.png")
	self.offScreen = false
	self.animSpeed = 0.2
	--self.anim = newAnimation(self.img, 70, 55, self.animSpeed, 5)
	self.anim = newAnimation(self.img, 130, 128, self.animSpeed, 7)
	self.anim:setMode("once")
	self.score = 100
	self.hitSound = love.audio.newSource("sound/Cow_Hurt.wav")
	self.hitSound:setVolume(0.5)
	return self
end

function bigbird:update(dt)
	self.x = self.x - self.speed * dt
	--print("big bird " .. self.x .. " " .. self.speed)
	if self.x < -37 or self.y >= lg.getHeight() then
		self.offScreen = true
	end
	self.anim:update(dt)
	if self.x <= 320 then
		self.y = self.y + self.speed * dt
		--if self.y <= 400 then
		--	self.y = self.y + self.speed * dt
		--end
	end
end

function bigbird:draw()
	--print("draw bird " .. self.x .. ", " .. self.y)
	self.anim:draw(self.x, self.y)
	--love.graphics.draw(self.img, self.x, self.y)
end

function bigbird:getBBox()
	return {x = self.x + 32, y = self.y + 43, w = 72, h = 32}
	--return {x = self.x + 17, y = self.y, w = 70, h = 55}
end

function bigbird:hit()
	self.hitSound:play()
	self.offScreen = true
	self.hitSound:rewind()
end
