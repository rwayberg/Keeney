pie ={}
pie.__index = pie

function pie.create(x, y, speed)
	local self = setmetatable({}, pie)
	self.x = x
	self.y = y
	self.speed = speed
	self.img = love.graphics.newImage("img/pie.png")
	self.offScreen = false
	return self
end

function pie:update(dt)
	self.x = self.x - self.speed * dt
	if self.x < -51 then
		self.offScreen = true
	end
end

function pie:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

function pie:getBBox()
	return {x = self.x, y = self.y, w = 50, h = 20}
end

function pie:changeSpeed(newSpeed)
	self.speed = newSpeed
end