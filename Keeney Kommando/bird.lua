bird = {MAX_SPEED = 30}
bird.__index = bird
local lg = love.graphics

function bird.create(x, y, speed)
	local self = setmetatable({}, bird)
	self.x = x
	self.y = y
	self.speed = speed
	self.img = lg.newImage("img/bird.png")
	self.offScreen = false
	self.animSpeed = 0.2
	self.anim = newAnimation(self.img, 50, 50, self.animSpeed, 10)
	self.anim:setMode("loop")
	return self
end

function bird:update(dt)
	self.x = self.x + self.speed * dt
	if self.x > lg.getWidth()then
		self.offScreen = true
	end
	self.anim:update(dt)
end

function bird:draw()
	self.anim:draw(self.x, self.y)
end