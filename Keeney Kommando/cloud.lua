cloud = {MAX_SPEED = 20}
cloud.__index = cloud
local lg = love.graphics

function cloud.create(x, y, speed)
	local self = setmetatable({}, cloud)
	--local self = {}
	self.x = x
	self.y = y
	self.speed = speed
	self.offScreen = false
	self.img = lg.newImage("img/cloud.png")
	
	return self
end

function cloud:update(dt)
	self.x = self.x - self.speed * dt
	if (self.x + self.img:getWidth()) < 0 then
		self.offScreen = true
	end
end

function cloud:draw()
	lg.draw(self.img, self.x, self.y)
end