steak = {SCORE = 200}
steak.__index = steak

function steak.create(x, y, speed)
	local self = setmetatable({}, steak)
	self.x = x
	self.y = y
	self.speed = speed
	self.offScreen = false
	self.img = love.graphics.newImage("img/steak.png")
	return self
end

function steak:update(dt)
	self.x = self.x - self.speed * dt
	if self.x < -69 then
		self.offScreen = true
	end
end

function steak:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

function steak:getBBox()
	return {x = self.x, y = self.y, w = 68, h = 44}
end

function steak:changeSpeed(newSpeed)
	self.speed  = newSpeed
end