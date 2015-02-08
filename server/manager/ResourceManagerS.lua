--[[
	Name: xrParticlesEditor
	Filename: ResourceManagerS.lua
	Author: Sam@ke
--]]

local classInstance = nil

ResourceManagerS = {}

function ResourceManagerS:constructor(parent)

	self.parent = parent
	self.mapPath = "[xrEffects]/[xrMaps]"
	self.author = "xrParticleEditor"
	self.mapPrefix = 0
	
	self.particleEffectMaps = {}
	self.particleEffectNames = {}
	
	self.m_SaveEffectMap = function(...) self:saveEffectMap(...) end
	addEvent("saveEffectMap", true)
	addEventHandler("saveEffectMap", root, self.m_SaveEffectMap)
	
	self.m_StopRunningEffectMaps = function(...) self:stopRunningEffectMaps(...) end
	addEvent("stopRunningEffectMaps", true)
	addEventHandler("stopRunningEffectMaps", root, self.m_StopRunningEffectMaps)
	
	self.m_LoadEffectMap = function(...) self:loadEffectMap(...) end
	addEvent("loadEffectMap", true)
	addEventHandler("loadEffectMap", root, self.m_LoadEffectMap)
	
	self.m_DeleteEffectMap = function(...) self:deleteEffectMap(...) end
	addEvent("deleteEffectMap", true)
	addEventHandler("deleteEffectMap", root, self.m_DeleteEffectMap)
	
	mainOutput("ResourceManagerS was started...")
end


function ResourceManagerS:update()
	self:refreshXRMaps()
end


function ResourceManagerS:saveEffectMap(mapName, overwrite)
	if (mapName) then
		local overwrite = overwrite
		local newMap = getResourceFromName(mapName)
		local mapName = mapName
		
		if (not newMap) then
			newMap = createResource(mapName, self.mapPath)
		else
			if (overwrite == true) then
				deleteResource(newMap)
				newMap = createResource(mapName, self.mapPath)
			else
				triggerClientEvent(source, "onMapAlreadyExist", source, mapName)
				return nil
			end
		end
		
		if (newMap) then
			self:writeMapInformations(newMap, mapName)
		else
			mainOutput("SERVER: Could´nt create map " .. mapName .. "!.")
		end
	end
end


function ResourceManagerS:writeMapInformations(map, mapName)
	if (map) and (mapName) then
		local map = map
		local mapName = mapName
		local writeResourceInfo = false
		
		writeResourceInfo = map:setInfo("type", "map")
		writeResourceInfo = map:setInfo("name", mapName)
		writeResourceInfo = map:setInfo("author", self.author)
		writeResourceInfo = map:setInfo("version", "1.0.0")
		writeResourceInfo = map:setInfo("description", mapName)
		writeResourceInfo = map:setInfo("mapType", "xrEffectMap")
		
		if (writeResourceInfo == false) then
			mainOutput("SERVER: Saving meta informations for map " .. mapName .. " failed!")
			return
		end
		
		local metaRoot = xmlLoadFile(":" .. mapName .. "/meta.xml" )
		
		if (metaRoot) then
			local mapNode = xmlFindChild(metaRoot, "map", 0)
			
			if (mapNode) then
				xmlDestroyNode(mapNode)
				xmlSaveFile(metaRoot)
			end
			
			mapNode = xmlCreateChild(metaRoot, "map")
			
			if (mapNode) then
				local attributeWrite = false
				attributeWrite = xmlNodeSetAttribute(mapNode, "src", mapName .. ".map")
				attributeWrite = xmlNodeSetAttribute(mapNode, "dimension", 0)
				
				if (attributeWrite ~= false) then
					xmlSaveFile(metaRoot)
				else
					mainOutput("SERVER: Adding mapfile for map " .. mapName .. " to 'meta.xml' failed!")
				end
			end
			
			local includeNode = xmlCreateChild(metaRoot, "include")
			
			if (includeNode) then
				local attributeWrite = false
				attributeWrite = xmlNodeSetAttribute(includeNode, "resource", "xrParticlesEditor")
				
				if (attributeWrite ~= false) then
					xmlSaveFile(metaRoot)
					xmlUnloadFile(metaRoot)
					
					self:saveMapElements(mapName)
				else
					mainOutput("SERVER: Adding particle resource for map " .. mapName .. " to 'meta.xml' failed!")
				end
			end
		else
			mainOutput("SERVER: 'meta.xml' for map " .. mapName .. " not found or corrupt!")
		end
	end
end


function ResourceManagerS:saveMapElements(mapName)
	if (mapName) then
		local mapName = mapName
		
		local mapFile = xmlCreateFile(":" .. mapName .. "/" .. mapName .. ".map", "map")
		
		if (mapFile) then
			for index, effect in pairs(getElementsByType("xrParticleEffect")) do
				if (effect) then
					local id = effect:getData("id")
					local texture = effect:getData("texture")
					local x = effect:getData("x")
					local y = effect:getData("y")
					local z = effect:getData("z")
					local maxParticles = effect:getData("maxParticles")
					local radius = effect:getData("radius")
					local turbulence = effect:getData("turbulence")
					local velocityX = effect:getData("velocityX")
					local velocityY = effect:getData("velocityY")
					local velocityZ = effect:getData("velocityZ")
					local effectRotation = effect:getData("effectRotation")
					local startParticleSize = effect:getData("startParticleSize")
					local endParticleSize = effect:getData("endParticleSize")
					local particleLifeTime = effect:getData("particleLifeTime")
					local effectBrightness = effect:getData("effectBrightness")
					local effectColorAlpha = effect:getData("effectColorAlpha")
					local effectColorRed = effect:getData("effectColorRed")
					local effectColorGreen = effect:getData("effectColorGreen")
					local effectColorBlue = effect:getData("effectColorBlue")
					local isRainBowColor = effect:getData("isRainBowColor")
					
					local effectNode = xmlCreateChild(mapFile, "xrParticleEffect")
			
					if (effectNode) then
						local attributeWrite = false
						attributeWrite = effectNode:setAttribute("id", id .. "byMAP")
						attributeWrite = effectNode:setAttribute("texture", texture)
						attributeWrite = effectNode:setAttribute("x", x)
						attributeWrite = effectNode:setAttribute("y", y)
						attributeWrite = effectNode:setAttribute("z", z)
						attributeWrite = effectNode:setAttribute("maxParticles", maxParticles)
						attributeWrite = effectNode:setAttribute("radius", radius)
						attributeWrite = effectNode:setAttribute("turbulence", turbulence)
						attributeWrite = effectNode:setAttribute("velocityX", velocityX)
						attributeWrite = effectNode:setAttribute("velocityY", velocityY)
						attributeWrite = effectNode:setAttribute("velocityZ", velocityZ)
						attributeWrite = effectNode:setAttribute("effectRotation", effectRotation)
						attributeWrite = effectNode:setAttribute("startParticleSize", startParticleSize)
						attributeWrite = effectNode:setAttribute("endParticleSize", endParticleSize)
						attributeWrite = effectNode:setAttribute("particleLifeTime", particleLifeTime)
						attributeWrite = effectNode:setAttribute("particleLifeTime", particleLifeTime)
						attributeWrite = effectNode:setAttribute("effectBrightness", effectBrightness)
						attributeWrite = effectNode:setAttribute("effectColorAlpha", effectColorAlpha)
						attributeWrite = effectNode:setAttribute("effectColorRed", effectColorRed)
						attributeWrite = effectNode:setAttribute("effectColorGreen", effectColorGreen)
						attributeWrite = effectNode:setAttribute("effectColorBlue", effectColorBlue)
						attributeWrite = effectNode:setAttribute("isRainBowColor", isRainBowColor)
						
						if (attributeWrite ~= false) then
							xmlSaveFile(mapFile)
						else
							mainOutput("SERVER: Adding element " .. id .. " to map " .. mapName .. " failed!")
						end
					end	
				end
			end
			
			xmlSaveFile(mapFile)
			xmlUnloadFile(mapFile)
			
			mainOutput("SERVER: Saving map '" .. mapName .. "' completed.")
			
			self:refreshXRMaps()
		else
			mainOutput("SERVER: Elements for map " .. mapName .. " couldnt be saved!")
		end
	end
end


function ResourceManagerS:loadEffectMap(mapName)
	if (mapName) then
		self:stopRunningEffectMaps()
		
		local resource = getResourceFromName(mapName)
		
		if (resource) then
			resource:start()
			
			if (resource:getState() == "running") then
				mainOutput("SERVER: Map '" .. mapName .. "' was loaded.")
			else
				mainOutput("SERVER: Map '" .. mapName .. "' couldnt be loaded.")
			end
		end
	end
end


function ResourceManagerS:deleteEffectMap(mapName)
	if (mapName) then
		local mapName = mapName
		local resource = getResourceFromName(mapName)
		
		if (resource) then
			local state = resource:getState()
			
			if (state == "running") then
				mainOutput("SERVER: Map '" .. mapName .. "'is currently running! Couldnt delete them.")
				resource:stop()
				return nil
			end
			
			deleteResource(resource)
		else
			mainOutput("SERVER: Map '" .. mapName .. "' not found.")
			return nil
		end
		
		resource = getResourceFromName(mapName)
		
		if (resource) then
			mainOutput("SERVER: Map '" .. mapName .. "' couldnt be deleted!")
		else
			mainOutput("SERVER: Map '" .. mapName .. "' was deleted.")
			triggerClientEvent(root, "refreshMapGridList", root)
		end
	end
end


function ResourceManagerS:stopRunningEffectMaps()
	self:refreshXRMaps()
	
    for index, xrMap in pairs(self.particleEffectMaps) do
		if (xrMap) then
			if (xrMap:getState() == "running") then
				xrMap:stop()
			end
		end
    end
end


function ResourceManagerS:refreshXRMaps()
	self.particleEffectMaps = {}
	self.particleEffectNames = {}
	
	for index, resource in pairs(getResources()) do
		if (resource) then
			local resourceType = resource:getInfo("type")
			local resourceMapType = resource:getInfo("mapType")

			if (resourceType) and (resourceMapType) then
				if (resourceType == "map") and (resourceMapType =="xrEffectMap") then
					table.insert(self.particleEffectNames, getResourceName(resource))
					table.insert(self.particleEffectMaps, resource)	
				end
			end
		end
	end
	
	triggerClientEvent("onMapListRefreshed", root, self.particleEffectNames)
end


function ResourceManagerS:destructor()
	removeEventHandler("saveEffectMap", root, self.m_SaveEffectMap)
	removeEventHandler("stopRunningEffectMaps", root, self.m_StopRunningEffectMaps)
	removeEventHandler("loadEffectMap", root, self.m_LoadEffectMap)
	removeEventHandler("deleteEffectMap", root, self.m_DeleteEffectMap)
	
	mainOutput("ResourceManagerS was stopped...")
end