
require("config")

local lg = love.graphics

y_default = 350
y = 0
x = 350
state = ""
jumping = false
falling = false
velocity_default = 300
velocity = 0
scale = .7
maxJump = 100
upVelocity = 50
downVelocity = -50
gravity = 10


WIDTH = 800
HEIGHT = 480

function love.load()
	loadConfig()
	y = y_default
	velocity = velocity_default
	state = "walking"
end

function setZoom()
	--local sw = love.graphics.getWidth()/WIDTH/config.scale
	--local sh = love.graphics.getHeight()/HEIGHT/config.scale
	--lg.scale(sw,sh)
end

function love.draw()
	lg.push()
	setZoom()
	cow = lg.newImage("img/cow1.png")
	lg.draw(cow, x, y, 0, scale)
	
	lg.pop()
	--scene = lg.newImage("img/background.png")
	--player = lg.newImage("img/cow1.png")
	--cloud = lg.newImage("img/cloud.png")
	--love.graphics.print("Hello World", 400, 300)
	--characterposition = {400, 400}
	
	--lg.draw(scene, lg.getWidth() /2 - scene:getWidth()/2, lg.getHeight()/2 - scene:getHeight()/2)
	
	--local drawn = false
	
	--if not drawn then
	--	lg.draw(player, characterposition[1] - player:getWidth()/2, characterposition[2] - player:getHeight())
	--end
end

function love.update(dt)
	if jumping then
		if not love.keyboard.isDown(" ") or y < maxJump then
			falling = true
		end
		
		if falling then
			velocity = velocity - gravity
		end
		
		y = y - velocity * dt
		
		--if falling then
		--	y = y - ((velocity * dt) - gravity) 
		--else
		--	y = y - velocity * dt
		--end
		
		--if y < maxJump or falling then -- down
		--	falling = true
		--	y = y + (velocity -  * dt)
		--	--y = y + (downVelocity * dt)
		--else --up
		--	y = y - (velocity * dt)
		--	--y = y - (upVelocity * dt)
		--end
		if y > y_default then
			y = y_default
			velocity = velocity_default
			jumping = false
			falling  = false
		end
		print("y: " .. y)
		print("velocity: " .. velocity * dt)
	end
end

function love.keypressed(k, uni)
	print("pressed " .. k)
	if k == " " and not jumping then
		jumping = true
	end
end



