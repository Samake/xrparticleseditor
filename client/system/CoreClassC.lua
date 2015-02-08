--[[
	Name: xrParticlesEditor
	Filename: CoreClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

CoreClassC = {}

function CoreClassC:constructor()
	mainOutput("CLIENT: xrParticleEditor was started.")
	
	self.configFile = xmlLoadFile("config.xml")
	triggerServerEvent("isEditorAllowedForClient", root, getLocalPlayer())
	
	if (self.configFile) then
	    self.startUpScreenNode = self.configFile:findChild("showStartUPScreen", 0)
		self.showStartupScreen = self.startUpScreenNode:getValue("showStartUPScreen")
		self.startupDurationNode = self.configFile:findChild("startUPDuration", 0)
		self.startupDuration = self.startupDurationNode:getValue("startUPDuration")
		self.showMTAHUDNode = self.configFile:findChild("showMTAHUD", 0)
		self.showMTAHUD = self.showMTAHUDNode:getValue("showMTAHUD")
		
		if (self.showStartupScreen) and (self.startupDuration) then
			if (self.showStartupScreen == "true") then
				if (not self.startUp) then
					self.startUp = new(StartupC, self, tonumber(self.startupDuration))
				end
			else
				self:startupCompleted()
			end
		else
			self:startupCompleted()
		end
			
		self.m_StartupCompleted = function() self:startupCompleted() end
		addEvent("startUpCompleted", true)
		addEventHandler("startUpCompleted", root, self.m_StartupCompleted)
		
		self.m_AllowEditorForClient = function(...) self:allowEditorForClient(...) end
		addEvent("allowEditorForClient", true)
		addEventHandler("allowEditorForClient", root, self.m_AllowEditorForClient)
		
		self.m_Update = function() self:update() end
		addEventHandler("onClientPreRender", root, self.m_Update)
	else
		mainOutput("CLIENT: Config file couldnt be loaded, please check syntax!")
		self:destructor()
		return nil
	end
	
	mainOutput("CoreClassC was started...")
end


function CoreClassC:startupCompleted()
	if (not self.elementManager) then
		self.elementManager = new(ElementManagerC, self)
	end
	
	if (not self.particleManager) then
		self.particleManager = new(ParticleEffect3DManagerC, self, self.configFile)
	end
	
	if (self.startUp) then
		delete(self.startUp)
		self.startUp = nil
	end
end


function CoreClassC:allowEditorForClient(bool)
	if (bool) and (bool == true) then
		self.editorEnabledOnStartNode = self.configFile:findChild("editorEnabledOnStart", 0)
		self.editorEnabledOnStart = self.editorEnabledOnStartNode:getValue("editorEnabledOnStart")
		self.keyOpenEditorNode = self.configFile:findChild("openEditor", 0)
		self.keyOpenEditor = self.keyOpenEditorNode:getValue("openEditor") or "m"
		
		if (self.editorEnabledOnStart) then
			if (self.editorEnabledOnStart == "true") then
				if (not self.editorClass) then
					self.editorClass = new(EditorClassC, self, self.configFile)
				end
			end
		else
			if (not self.editorClass) then
				self.editorClass = new(EditorClassC, self, self.configFile)
			end
		end
		
		if (not self.presetHandler) then
			self.presetHandler = new(PresetHandlerC, self)
		end
		
		self.m_ToggleEditor = function(...) self:toggleEditor(...) end
		bindKey(self.keyOpenEditor, "down", self.m_ToggleEditor)
	end
end


function CoreClassC:update()
	if (self.showMTAHUD == "false") then
		setPlayerHudComponentVisible("all", false)
	end
	
	if (self.elementManager) then
		self.elementManager:update()
	end
	
	if (self.particleManager) then
		self.particleManager:update()
	end

	if (self.editorClass) then
		self.editorClass:update()
	end
end


function CoreClassC:toggleEditor()
	if (not self.editorClass) then
		self.editorClass = new(EditorClassC, self, self.configFile)
	else
		delete(self.editorClass)
		self.editorClass = nil
	end
end


function CoreClassC:destructor()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	removeEventHandler("startUpCompleted", root, self.m_StartupCompleted)
	removeEventHandler("allowEditorForClient", root, self.m_AllowEditorForClient)
	
	unbindKey("M", "down", self.m_ToggleEditor)
	
	setPlayerHudComponentVisible("all", true)
	
	if (self.configFile) then
		self.configFile:unload()
		self.configFile = nil
	end
	
	if (self.startUp) then
		delete(self.startUp)
		self.startUp = nil
	end
	
	if (self.presetHandler) then
		delete(self.presetHandler)
		self.presetHandler = nil
	end
	
	if (self.elementManager) then
		delete(self.elementManager)
		self.elementManager = nil
	end
	
	if (self.particleManager) then
		delete(self.particleManager)
		self.particleManager = nil
	end
	
	if (self.editorClass) then
		delete(self.editorClass)
		self.editorClass = nil
	end
	

	mainOutput("CoreClassC was stopped...")
	mainOutput("CLIENT: xrParticleEditor was stopped.")
end


addEventHandler("onClientResourceStart", resourceRoot, 
function()
	classInstance = new(CoreClassC)
end)


addEventHandler("onClientResourceStop", resourceRoot, 
function()
	if (classInstance) then
		delete(classInstance)
		classInstance = nil
	end
end)