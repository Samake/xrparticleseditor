--[[
	Name: xrParticlesEditor
	Filename: xrUtils.lua
	Authors: Sam@ke, Jusonex, ZuluTangoDelta
--]]

-- ############# mainOutput ############## --
function mainOutput(text)
	if (string.find(text, "CLIENT", 1, true)) then
		outputChatBox("#CCFF00 XRMODULES >> #FFFF99" .. text, 255, 255, 255, true)
	elseif (string.find(text, "SERVER", 1, true)) then
		outputChatBox("#CCFF00 XRMODULES >> #FFCC99" .. text, root, 255, 255, 255, true)
	else
		outputDebugString(text, 3)
	end
end


-- ############# getAttachedPosition ############## -- 
function getAttachedPosition(x, y, z, rx, ry, rz, distance, angleAttached, height)
 
    local nrx = math.rad(rx);
    local nry = math.rad(ry);
    local nrz = math.rad(angleAttached - rz);
    
    local dx = math.sin(nrz) * distance;
    local dy = math.cos(nrz) * distance;
    local dz = math.sin(nrx) * distance;
    
    local newX = x + dx;
    local newY = y + dy;
    local newZ = (z + height) - dz;
    
    return newX, newY, newZ;
end


-- ############# findRotation ############## -- 
function findRotation(x1, y1, x2, y2)
  local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
  if t < 0 then t = t + 360 end;
  return t;
end


-- ############# math.round ############## -- 
function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


-- ############# getCameraRotation ############## -- 
function getCameraRotation ()
	local px, py, pz, lx, ly, lz = getCameraMatrix()
	local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
 	local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
	--Convert to degrees
	rotx = math.deg(rotx)
	rotz = -math.deg(rotz)
	
 	return rotx, 180, rotz
end


-- ############# dxDrawCircle3D ############## -- 
function dxDrawCircle3D(x, y, z, radius, segments, color, width)
    segments = segments or 16
    color = color or tocolor(255, 255, 0, 255)
    width = width or 1
    local segAngle = 360 / segments
    local fX, fY, tX, tY
    for i = 1, segments do
        fX = x + math.cos(math.rad(segAngle * i)) * radius
        fY = y + math.sin(math.rad(segAngle * i)) * radius
        tX = x + math.cos(math.rad(segAngle * (i+1))) * radius
        tY = y + math.sin(math.rad(segAngle * (i+1))) * radius
        dxDrawLine3D(fX, fY, z, tX, tY, z, color, width)
		dxDrawLine3D(x, y, z, tX, tY, z, color, width)
    end
end


-- ############# getClientFPS ############## -- 
local clientFpsVar = 0
local clientFpsStartTick = false
local clientFpsCurrentTick = 0

function getClientFPS()
    
    if not (clientFpsStartTick) then
        clientFpsStartTick = getTickCount()
    end
        
    clientFpsVar = clientFpsVar + 1
    clientFpsCurrentTick = getTickCount()
        
    if ((clientFpsCurrentTick - clientFpsStartTick) >= 1000) then
        clientFps = clientFpsVar
        
        clientFpsVar = 0
        clientFpsStartTick = false
    end
    
    if (clientFps) then
		return clientFps
    else
        return 0
    end
end