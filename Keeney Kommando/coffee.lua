coffee = {}
coffee.__index = coffee

function coffee.create(x, y, speed)
	local self = setmetatable({}, coffee)
	self.x = x
	self.y = y
	self.speed = speed
	self.offScreen = false
	self.img = love.graphics.newImage("img/coffee.png")
	self.anim_speed = 0.2
	self.coffee_anim = newAnimation(self.img, 40, 54, self.anim_speed, 4)
	return self
end

function coffee:update(dt)
	self.coffee_anim:update(dt)
	self.x = self.x - self.speed * dt
	if self.x < -32 then
		self.offScreen = true
	end
end

function coffee:draw()
	--love.graphics.draw(self.img, self.x, self.y)
	self.coffee_anim:draw(self.x, self.y)
end

function coffee:getBBox()
	return {x = self.x + 15, y = self.y, w = 32, h = 43}
end

function coffee:changeSpeed(newSpeed)
	self.speed  = newSpeed
end