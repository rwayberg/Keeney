bullet = {DMG = 1}
bullet.__index = bullet

function bullet.create(x, y)
	local self = setmetatable({}, bullet)
	self.x = x
	self.y = y
	self.speed = 460
	self.img = love.graphics.newImage("img/bullet.png")
	self.offScreen = false
	return self
end

function bullet:update(dt)
	self.x = self.x + self.speed * dt
	if self.x > (love.graphics.getWidth() - 50) then
		self.offScreen = true
	end
end

function bullet:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

function bullet:getBBox()
	return {x = self.x+25, y = self.y, w = 5, h = 5}
end