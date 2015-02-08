--[[
	Name: MTA:Mario Kart
	Filename: PresetHandlerC.lua
	Author: Sam@ke
--]]

PresetHandlerC = {}

function PresetHandlerC:constructor(parent)
	mainOutput("PresetHandlerC was started...")
	
	self.parent = parent
	self.presetPath = "presets/"
	self.availablePresets = {}
	
	self.m_LoadPreset = function(...) self:loadPreset(...) end
	addEvent("loadPreset", true)
	addEventHandler("loadPreset", root, self.m_LoadPreset)
	
	self.m_SavePreset = function(...) self:savePreset(...) end
	addEvent("savePreset", true)
	addEventHandler("savePreset", root, self.m_SavePreset)
	
	self.m_DoSavePreset = function(...) self:doSavePreset(...) end
	addEvent("doSavePreset", true)
	addEventHandler("doSavePreset", root, self.m_DoSavePreset)
	
	self.m_OnPresetDelete = function(...) self:onPresetDelete(...) end
	addEvent("onPresetDelete", true)
	addEventHandler("onPresetDelete", root, self.m_OnPresetDelete)
	
	self.m_OnPresetListRequested = function(...) self:onPresetListRequested(...) end
	addEvent("onPresetListRequested", true)
	addEventHandler("onPresetListRequested", root, self.m_OnPresetListRequested)
end


function PresetHandlerC:loadPreset(preset)
	if (preset) then
		local preset = preset
		local presetFile = xmlLoadFile(self.presetPath .. preset .. ".xml")
		
		if (not presetFile) then
			mainOutput("CLIENT: Preset " .. preset .. " was not found.")
		else
			local presetAttributes = {}
			local node = xmlFindChild(presetFile, "texture", 0)
			
			if (node) then
				presetAttributes.texture = tostring(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'texture' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "maxParticles", 0)
			
			if (node) then
				presetAttributes.maxParticles = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'maxParticles' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "radius", 0)
			
			if (node) then
				presetAttributes.radius = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'radius' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "turbulence", 0)
			
			if (node) then
				presetAttributes.turbulence = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'turbulence' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "velocityX", 0)
			
			if (node) then
				presetAttributes.velocityX = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'velocityX' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "velocityY", 0)
			
			if (node) then
				presetAttributes.velocityY = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'velocityY' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "velocityZ", 0)
			
			if (node) then
				presetAttributes.velocityZ = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'velocityZ' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectRotation", 0)
			
			if (node) then
				presetAttributes.effectRotation = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectRotation' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "startParticleSize", 0)
			
			if (node) then
				presetAttributes.startParticleSize = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'startParticleSize' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "endParticleSize", 0)
			
			if (node) then
				presetAttributes.endParticleSize = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'endParticleSize' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "particleLifeTime", 0)
			
			if (node) then
				presetAttributes.particleLifeTime = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'particleLifeTime' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectBrightness", 0)
			
			if (node) then
				presetAttributes.effectBrightness = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectBrightness' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectColorRed", 0)
			
			if (node) then
				presetAttributes.effectColorRed = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectColorRed' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectColorGreen", 0)
			
			if (node) then
				presetAttributes.effectColorGreen = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectColorGreen' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectColorBlue", 0)
			
			if (node) then
				presetAttributes.effectColorBlue = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectColorBlue' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "effectColorAlpha", 0)
			
			if (node) then
				presetAttributes.effectColorAlpha = tonumber(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'effectColorAlpha' is nil.")
				return nil
			end
			
			node = xmlFindChild(presetFile, "isRainBowColor", 0)
			
			if (node) then
				presetAttributes.isRainBowColor = tostring(xmlNodeGetValue(node))
			else 
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be loaded. Value 'isRainBowColor' is nil.")
				return nil
			end

			triggerEvent("onPresetWasLoaded", root, presetAttributes)
			mainOutput("CLIENT: Preset " .. preset .. " was loaded successfully.")
		end
	end
end


function PresetHandlerC:onPresetListRequested()
	self.availablePresets = {}
	local presetListFile = xmlLoadFile(self.presetPath .. "presetlist.xml")
	
	if (not presetListFile) then
		triggerEvent("presetListRefreshed", root, self.availablePresets)
		return nil
	end
	
	for i = 1, 99999, 1 do
		local id = "preset" .. i
		local node = xmlFindChild(presetListFile, id, 0)
		local value = nil
			
		if (node) then
			 value = xmlNodeGetValue(node)
			 self.availablePresets[i] = value
		end
	end
	
	xmlUnloadFile(presetListFile)
	
	triggerEvent("presetListRefreshed", root, self.availablePresets)
end


function PresetHandlerC:savePreset(preset, element)
	if (preset) and (element) then
		local preset = preset
		local presetFile = xmlLoadFile(self.presetPath .. preset .. ".xml")
		
		if (not presetFile) then
			self:doSavePreset(preset, element)
		else
			triggerEvent("onPresetAlreadyExist", root, preset)
		end
	end
end


function PresetHandlerC:doSavePreset(preset, element)
	if (preset) and (element) then
		local preset = preset
		local element = element
		local presetFile = xmlLoadFile(self.presetPath .. preset .. ".xml")
		
		if (not presetFile) then
			presetFile = xmlCreateFile(self.presetPath .. preset .. ".xml", "settings")
			
			if (not presetFile) then
				mainOutput("CLIENT: Preset " .. preset .. " couldnt created.")
				return nil
			end
		end
		
		local presetAttributes = {}
		
		presetAttributes.texture = element:getData("texture") or nil
		presetAttributes.maxParticles = element:getData("maxParticles") or nil
		presetAttributes.radius = element:getData("radius") or nil
		presetAttributes.turbulence = element:getData("turbulence") or nil
		presetAttributes.velocityX = element:getData("velocityX") or nil
		presetAttributes.velocityY = element:getData("velocityY") or nil
		presetAttributes.velocityZ = element:getData("velocityZ") or nil
		presetAttributes.effectRotation = element:getData("effectRotation") or nil
		presetAttributes.startParticleSize = element:getData("startParticleSize") or nil
		presetAttributes.endParticleSize = element:getData("endParticleSize") or nil
		presetAttributes.particleLifeTime = element:getData("particleLifeTime") or nil
		presetAttributes.effectBrightness = element:getData("effectBrightness") or nil
		presetAttributes.effectColorRed = element:getData("effectColorRed") or nil
		presetAttributes.effectColorGreen = element:getData("effectColorGreen") or nil
		presetAttributes.effectColorBlue = element:getData("effectColorBlue") or nil
		presetAttributes.effectColorAlpha = element:getData("effectColorAlpha") or nil
		presetAttributes.isRainBowColor = element:getData("isRainBowColor") or nil
		
		for attribute, value in pairs(presetAttributes) do
			if (value) then
				local node = xmlFindChild(presetFile, attribute, 0)
				
				if (node) then
					 xmlNodeSetValue(node, value)
				else
					node = xmlCreateChild(presetFile, attribute)
					
					if (node) then
						 xmlNodeSetValue(node, value)
					else
						mainOutput("CLIENT: Preset " .. preset .. " couldnt be saved.")
					end
				end
			else
				mainOutput("CLIENT: Preset " .. preset .. " couldnt be saved. No value for " .. tostring(attribute) .. " was found!")
				return nil
			end
		end
	
		xmlSaveFile(presetFile)
		xmlUnloadFile(presetFile)
		
		self:handlePresetFiles(preset)
		triggerEvent("onPresetWasLoaded", root, presetAttributes)
		
		mainOutput("CLIENT: Preset " .. preset .. " was saved successfully.")
	end
end


function PresetHandlerC:handlePresetFiles(preset)
	if (preset) then
		local preset = preset

		self.availablePresets[#self.availablePresets + 1] = preset
		
		local presetListFile = xmlLoadFile(self.presetPath .. "presetlist.xml")
			
			if (not presetListFile) then
				presetListFile = xmlCreateFile(self.presetPath .. "presetlist.xml", "presets")
				
				if (not presetListFile) then
					mainOutput("CLIENT: Preset list couldnt created.")
					return nil
				else
					mainOutput("CLIENT: Preset list created successfully.")
				end
			end
		
		local presetAlreadyExist = "false"
		
		for i = 1, #self.availablePresets, 1 do
			local id = "preset" .. i
			
			local node = xmlFindChild(presetListFile, id, 0)
			local value
			
			if (node) then
				value = xmlNodeGetValue(node)
				
				if (value == preset) then
					xmlNodeSetValue(node, self.availablePresets[i])
					presetAlreadyExist = "true"
				end
			else
				if (presetAlreadyExist == "false") then
					node = xmlCreateChild(presetListFile, id)
							
					if (node) then
						 xmlNodeSetValue(node, self.availablePresets[i])
					else
						mainOutput("CLIENT: Preset " .. preset .. " couldnt added to preset list.")
					end
				end
			end
		end
		
		xmlSaveFile(presetListFile)
		xmlUnloadFile(presetListFile)
		
		self:onPresetListRequested()
		
		mainOutput("CLIENT: Preset list were refreshed.")
	end
end


function PresetHandlerC:onPresetDelete(preset)
	if (preset) then
		local preset = preset
		local presetFile = xmlLoadFile(self.presetPath .. preset .. ".xml")
		
		if (not presetFile) then
			mainOutput("CLIENT: Could´nt delete " .. preset .. ". Preset not found.")
		else
			fileDelete (self.presetPath .. preset .. ".xml")
			
			local presetFile = xmlLoadFile(self.presetPath .. preset .. ".xml")
			
			if (not presetFile) then
				self:deletePresetFromList(preset)
				mainOutput("CLIENT: Preset " .. preset .. " deleted.")
			else
				mainOutput("CLIENT: Deletion of preset " .. preset .. " failed.")
			end
		end
	end
end


function PresetHandlerC:deletePresetFromList(preset)
	if (preset) then
		local preset = preset
		local presetListFile = xmlLoadFile(self.presetPath .. "presetlist.xml")
		
		if (presetListFile) then		
			for i = 1, 99999, 1 do
				local id = "preset" .. i
				local node = xmlFindChild(presetListFile, id, 0)
					
				if (node) then
					value = xmlNodeGetValue(node)
					
					if (value) then
						if (value == preset) then
							xmlDestroyNode(node)
						end
					end
				end
			end
		end
		
		xmlSaveFile(presetListFile)
		xmlUnloadFile(presetListFile)
	
		self:onPresetListRequested()
	end
end


function PresetHandlerC:destructor()
	removeEventHandler("loadPreset", root, self.m_LoadPreset)
	removeEventHandler("savePreset", root, self.m_SavePreset)
	removeEventHandler("doSavePreset", root, self.m_DoSavePreset)
	removeEventHandler("onPresetDelete", root, self.m_OnPresetDelete)
	removeEventHandler("onPresetListRequested", root, self.m_OnPresetListRequested)
	
	self.availablePresets = nil
		
	mainOutput("CLIENT: PresetHandlerC was deleted...")
end