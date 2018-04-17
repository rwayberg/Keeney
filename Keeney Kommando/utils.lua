
function math.round(x)
	return math.floor(x+0.5)
end

function cap(val, min, max)
	return math.max(math.min(val, max), min)
end

function wrap(val, min, max)
	if val < min then val = max end
	if val > max then val = min end
	return val
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; local i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function newPaddedImage(filename)
    local source = love.image.newImageData(filename)
    local w, h = source:getWidth(), source:getHeight()
    
    -- Find closest power-of-two.
    local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
    local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))
    
    -- Only pad if needed:
    if wp ~= w or hp ~= h then
        local padded = love.image.newImageData(wp, hp)
        padded:paste(source, 0, 0)
        return love.graphics.newImage(padded)
    end
    
    return love.graphics.newImage(source)
end