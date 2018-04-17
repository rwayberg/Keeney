hud = {SCORE = 0, SCOUNT = 0, START_LIFE = 3}
hud.__index = hud

function hud.create()
	local self = setmetatable({}, hud)
	self.img = love.graphics.newImage("img/hud40.png")
	self.steakimg = love.graphics.newImage("img/steak.png")
	self.lifeimg = love.graphics.newImage("img/life.png")
	self.x = 0
	self.y = 0
	self.score = self.SCORE
	self.steakCount = self.SCOUNT
	self.steakX = 630
	self.steakY = 8
	self.lifeX = 10
	self.lifeY = 5
	self.lifeCount = 0--self.START_LIFE
	self.lifeOffSet = self.lifeimg:getWidth() + 10
	self.font = love.graphics.newFont("fonts/slkscr.ttf", 32)
	
	return self
end

function hud:draw()
	love.graphics.setFont(self.font)
	love.graphics.draw(self.img, self.x, self.y)
	love.graphics.draw(self.steakimg, self.steakX, self.steakY, 0, .6, .5)
	love.graphics.print(self.score, 200, 2)
	love.graphics.print(" X " .. self.steakCount, self.steakX + 40, 2)
	local lifeSet = self.lifeX
	for i=0,self.lifeCount-1,1 do
		lifeSet = i * self.lifeOffSet
		love.graphics.draw(self.lifeimg, self.lifeX + lifeSet, self.selfY)
	end
end

function hud:addScore(addScore)
	self.score = self.score + addScore
end

function hud:addSteak(addSteak)
	self.steakCount = self.steakCount + addSteak
end

function hud:removeLife(count)
	if self.lifeCount > 0 then
		self.lifeCount = self.lifeCount - 1
	else
		self.lifeCount = 0
	end
end