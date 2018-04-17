default_config = {
	scale = 3,
	keys = {
		up = "up", down = "down", left = "left", right = "right", escapce = "escape", rctrl = "rctrl", space = " "
	}
}

function loadConfig()
	--if unexpected_condition then error() end
	if love.Open_GL_Enabled then
		canvas = lg.newCanvas(256,256)
	end
	config = {}
	for i,v in pairs(default_config) do
		if type(v) == "table" then
			config[i] = {}
			for j,w in pairs(v) do
				config[i][j] = w
			end
		else
			config[i] = v
		end
	end
	
end