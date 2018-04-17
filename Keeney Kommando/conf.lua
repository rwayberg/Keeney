function love.conf(t)
    t.title = "Keeney Kommando"        
    t.author = "Undecided Games"        
    t.url = nil
    t.identity = "Keeney Kommando"
	t.console = false
    t.version = "0.8.0"              
    t.release = true
	t.screen.width = 800
    t.screen.height = 480
    t.screen.fullscreen = false 
    t.screen.vsync = false       
    t.screen.fsaa = 0           
    t.modules.mouse = false      
    t.modules.physics = false
	t.game_version = 1.0
end

love.fps = 60
love.Open_GL_Enabled = true