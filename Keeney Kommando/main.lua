require("menu")
require("config")
require("ingame")
require("scores")
require("utils")
require("cloud")
require("bird")
require("cow")
require("player")
require("bullet")
require("hud")
require("gameover")
require("AnAL")
require("sick")
require("steak")
require("pie")
require("coffee")
require("bigbird")

local lg = love.graphics

STATE_MENU, STATE_INGAME, STATE_SCORE, GAME_OVER = 0,1,2,3
gamestates = {[0] = menu, [1] = ingame, [2] = scores, [3] = gameover}

WIDTH = 800
HEIGHT = 480
local MAX_FRAMETIME = 1/20
local MIN_FRAMETIME = 1/60

function love.load()
	loadConfig()
	--check for scores
	highscore.set("highscores.lua", 10, "AAA", 100)
	print(highscore.count())
	--make new scores
	if highscore.count() == 0 then
		print("make new high scores")
		highscore.add("JJJ", 200)
		highscore.add("III", 200)
		highscore.add("HHH", 300)
		highscore.add("GGG", 400)
		highscore.add("FFF", 500)
		highscore.add("EEE", 600)
		highscore.add("DDD", 700)
		highscore.add("CCC", 800)
		highscore.add("BBB", 900)
		highscore.add("AAA", 1000)
		highscore.save()
	end
	--sound
	selectAudio = love.audio.newSource("sound/Blip_Select.wav", "static")
	selectAudio:setVolume(0.3)
	enterSound = love.audio.newSource("sound/EnterSelect.wav", "static")
	enterSound:setVolume(0.3)
	--
	menu.enter()
end

function setZoom()
	--local sw = love.graphics.getWidth()/WIDTH/config.scale
	--local sh = love.graphics.getHeight()/HEIGHT/config.scale
	--lg.scale(sw,sh)
end

function love.draw()
	lg.push()
	--setZoom()
	
	gamestates[state].draw()
	--love.graphics.print(love.timer.getFPS(), 10, 10, 0, 1, 1)
	lg.pop()
end

function love.run()
	
	math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    local dt = 0
	tInitial = love.timer.getMicroTime()
	tPrevious = tInitial

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
			tCurrent = love.timer.getMicroTime()
			fpsCurrent = math.floor(1/(tCurrent-tPrevious))
			--print(fpsCurrent, 1/(tCurrent-tPrevious), tCurrent-tInitial)
			tPrevious = tCurrent
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        if love.timer then love.timer.sleep(1/love.fps) end
        if love.graphics then love.graphics.present() end
    end
end

function love.update(dt)

	--dt = math.min(dt, 1/60)
	gamestates[state].update(dt)
end

function love.keypressed(k, uni)
	gamestates[state].keypressed(k, uni)
end

function love.releaseerrhand(msg)
	    print("An error has occured, the game has been stopped.")

    if not love.graphics or not love.event or not love.graphics.isCreated() then
        return
    end

    love.graphics.setCanvas()
    love.graphics.setPixelEffect()

    -- Load.
    if love.audio then love.audio.stop() end
    love.graphics.reset()
    love.graphics.clear()

    local err = {}

    p = string.format("An error has occured that caused %s to stop.\nYou can notify %s about this%s.\n\nError: %s", love._release.title or "this game", love._release.author or "the author", love._release.url and " at " .. love._release.url or "", msg)

    local function draw()
        love.graphics.clear()
		menuscene = lg.newImage("img/ErrorPage.png")
		local sw = love.graphics.getWidth()/ menuscene:getWidth()
		local sh = love.graphics.getHeight()/ menuscene:getHeight()
		lg.draw(menuscene,  lg.getWidth() / 2 - menuscene:getWidth() / 2 * sw, lg.getHeight() / 2 - menuscene:getHeight() / 2 * sh, 0, sw, sh)
		font = lg.newFont("fonts/slkscr.ttf", 48)
		lg.setFont(font)
		lg.setColor(255,255,255)
		lg.print("Sorry", (lg.getWidth() /2) - 70, (lg.getHeight() /2) - 100)
		lg.print("There was an error!", (lg.getWidth() /2) - 280, (lg.getHeight() /2) - 30)
        love.graphics.present()
    end

    draw()

    local e, a, b, c
    while true do
        e, a, b, c = love.event.wait()

        if e == "quit" then
            return
        end
        if e == "keypressed" and a == "escape" then
            return
        end

        draw()

    end
end



