function love.conf(t)
    t.title = "Proto"        
    t.author = "Undecided"        
    t.url = nil
    t.identity = nil
	t.console = true 
    t.version = "0.8.0"              
    t.release = false
	t.screen.width = 800
    t.screen.height = 480
    --t.screen.width = 1000
    --t.screen.height = 480
    t.screen.fullscreen = false 
    t.screen.vsync = true       
    t.screen.fsaa = 0           
    t.modules.mouse = false      
    t.modules.physics = false
end