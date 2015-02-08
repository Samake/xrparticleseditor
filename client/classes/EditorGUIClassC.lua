--[[
	Name: xrParticlesEditor
	Filename: EditorGUIClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

EditorGUIClassC = {}

function EditorGUIClassC:constructor(parent, configFile)

	self.parent = parent
	self.configFile = configFile
	self.player = getLocalPlayer()
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.settingsPanelWidth, self.settingsPanelHeight = 200, 750
	self.mainPanelWidth, self.mainPanelHeight = 500, 40
	
	self.texture = ""
	self.x = 0
	self.y = 0
	self.y = 0
	self.maxParticles = 0
	self.radius = 0
	self.turbulence = 0
	self.velocityX = 0
	self.velocityY = 0
	self.velocityZ = 0
	self.effectRotation = 0
	self.startParticleSize = 0
	self.endParticleSize = 0
	self.particleLifeTime = 0
	self.brightness = 0
	self.alpha = 0
	self.isRainBowColors = "false"
	
	self.selectedEffect = nil
	self.selectedGUIElement = nil
	
	self.presetList = {}
	self.mapList = {}
	
	if (self.configFile) then
		self.maxParticlesCountNode = self.configFile:findChild("maxParticlesCount", 0)
		self.maxParticlesCount = self.maxParticlesCountNode:getValue("maxParticlesCount") or 1024
		self.maxRadiusValueNode = self.configFile:findChild("maxRadiusValue", 0)
		self.maxRadiusValue = self.maxRadiusValueNode:getValue("maxRadiusValue") or 35
		self.maxTurbulenceValueNode = self.configFile:findChild("maxTurbulenceValue", 0)
		self.maxTurbulenceValue = self.maxTurbulenceValueNode:getValue("maxTurbulenceValue") or 1
		self.maxVelocityXValueNode = self.configFile:findChild("maxVelocityXValue", 0)
		self.maxVelocityXValue = self.maxVelocityXValueNode:getValue("maxVelocityXValue") or 1
		self.maxVelocityYValueNode = self.configFile:findChild("maxVelocityYValue", 0)
		self.maxVelocityYValue = self.maxVelocityYValueNode:getValue("maxVelocityYValue") or 1
		self.maxVelocityZValueNode = self.configFile:findChild("maxVelocityZValue", 0)
		self.maxVelocityZValue = self.maxVelocityZValueNode:getValue("maxVelocityZValue") or 1
		self.maxRotationValueNode = self.configFile:findChild("maxRotationValue", 0)
		self.maxRotationValue = self.maxRotationValueNode:getValue("maxRotationValue") or 25
		self.maxStartSizeValueNode = self.configFile:findChild("maxStartSizeValue", 0)
		self.maxStartSizeValue = self.maxStartSizeValueNode:getValue("maxStartSizeValue") or 15
		self.maxEndSizeValueNode = self.configFile:findChild("maxEndSizeValue", 0)
		self.maxEndSizeValue = self.maxEndSizeValueNode:getValue("maxEndSizeValue") or 15
		self.maxBrightnessValueNode = self.configFile:findChild("maxBrightnessValue", 0)
		self.maxBrightnessValue = self.maxBrightnessValueNode:getValue("maxBrightnessValue") or 1
		self.maxAlphaValueNode = self.configFile:findChild("maxAlphaValue", 0)
		self.maxAlphaValue = self.maxAlphaValueNode:getValue("maxAlphaValue") or 255
		
		self.maxParticlesCount = tonumber(self.maxParticlesCount)
		self.maxRadiusValue = tonumber(self.maxRadiusValue)
		self.maxTurbulenceValue = tonumber(self.maxTurbulenceValue)
		self.maxVelocityXValue = tonumber(self.maxVelocityXValue)
		self.maxVelocityYValue = tonumber(self.maxVelocityYValue)
		self.maxVelocityZValue = tonumber(self.maxVelocityZValue)
		self.maxRotationValue = tonumber(self.maxRotationValue)
		self.maxStartSizeValue = tonumber(self.maxStartSizeValue)
		self.maxEndSizeValue = tonumber(self.maxEndSizeValue)
		self.maxLifeTimeValue = 35010	
		self.maxBrightnessValue = tonumber(self.maxBrightnessValue)
		self.maxAlphaValue = tonumber(self.maxAlphaValue)
	else
		self.maxParticlesCount = 1024
		self.maxRadiusValue = 35
		self.maxTurbulenceValue = 1
		self.maxVelocityXValue = 1
		self.maxVelocityYValue = 1
		self.maxVelocityZValue = 1
		self.maxRotationValue = 25
		self.maxStartSizeValue = 15
		self.maxEndSizeValue = 15	
		self.maxLifeTimeValue = 35010	
		self.maxBrightnessValue = 1
		self.maxAlphaValue = 255
	end
	
	-- ################# Editor Main ################# --
	self.editorMainWindow = guiCreateStaticImage(0, 0, self.screenWidth, self.mainPanelHeight, "res/textures/misc/blackBG.png", false)
	self.editorleftFrame = guiCreateStaticImage(0, 0, 0.33, 1, "res/textures/misc/editorMainBG.png", true, self.editorMainWindow)
	self.editorMiddleFrame = guiCreateStaticImage(0.33, 0, 0.34, 1, "res/textures/misc/editorMainBG.png", true, self.editorMainWindow)
	self.editorRightFrame = guiCreateStaticImage(0.67, 0, 0.33, 1, "res/textures/misc/editorMainBG.png", true, self.editorMainWindow)
	
	self.posXLabel = guiCreateLabel(0.05, 0.1, 0.3, 0.5, "x: ", true, self.editorleftFrame)
	guiLabelSetHorizontalAlign(self.posXLabel, "left")
	guiLabelSetColor(self.posXLabel, 128, 128, 255)
	
	self.posYLabel = guiCreateLabel(0.4, 0.1, 0.3, 0.5, "y: ", true, self.editorleftFrame)
	guiLabelSetHorizontalAlign(self.posYLabel, "left")
	guiLabelSetColor(self.posYLabel, 128, 128, 255)
	
	self.posZLabel = guiCreateLabel(0.75, 0.1, 0.3, 0.5, "z: ", true, self.editorleftFrame)
	guiLabelSetHorizontalAlign(self.posZLabel, "left")
	guiLabelSetColor(self.posZLabel, 128, 128, 255)
	
	self.editorModeLabel = guiCreateLabel(0.05, 0.48, 0.8, 0.5, "Editor Mode: ", true, self.editorleftFrame)
	guiLabelSetHorizontalAlign(self.editorModeLabel, "left")
	guiLabelSetColor(self.editorModeLabel, 165, 128, 165)
	
	self.allParticlesLabel = guiCreateLabel(0.05, 0.1, 0.5, 0.5, "Possible Particles (all): 0", true, self.editorRightFrame)
	guiLabelSetHorizontalAlign(self.allParticlesLabel, "left")
	guiLabelSetColor(self.allParticlesLabel, 125, 200, 150)
	
	self.streamedInParticlesLabel = guiCreateLabel(0.05, 0.48, 0.5, 0.5, "Possible Particles (streamed in): 0", true, self.editorRightFrame)
	guiLabelSetHorizontalAlign(self.streamedInParticlesLabel, "left")
	guiLabelSetColor(self.streamedInParticlesLabel, 125, 200, 150)
	
	self.streamedInActiveParticlesLabel = guiCreateLabel(0.65, 0.48, 0.5, 0.5, "Current Particles: 0", true, self.editorRightFrame)
	guiLabelSetHorizontalAlign(self.streamedInActiveParticlesLabel, "left")
	guiLabelSetColor(self.streamedInActiveParticlesLabel, 255, 255, 128)
	
	self.fpsLabel = guiCreateLabel(0.65, 0.1, 0.15, 0.5, "FPS: 0", true, self.editorRightFrame)
	guiLabelSetHorizontalAlign(self.fpsLabel, "left")
	guiLabelSetColor(self.fpsLabel, 255, 100, 25)
	
	self.newMapButton = guiCreateButton (0.02, 0.2, 0.3, 0.6, "New Map",true, self.editorMiddleFrame)
	self.loadMapButton = guiCreateButton (0.35, 0.2, 0.3, 0.6, "Load Map",true, self.editorMiddleFrame)
	self.saveMapButton = guiCreateButton (0.68, 0.2, 0.3, 0.6, "Save Map",true, self.editorMiddleFrame)
	
	guiSetVisible(self.editorMainWindow, true)
	guiBringToFront(self.editorMainWindow)
	
	-- ################# NEW MAP WINDOW ################# --
	self.newMapWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 100, 300, 100, "New Map", false)
	
	self.newMap1Label = guiCreateLabel(0.05, 0.22, 0.8, 0.2, "Are you sure to set 'New Map'?", true, self.newMapWindow)
	guiLabelSetHorizontalAlign(self.newMap1Label, "left")
	guiLabelSetColor(self.newMap1Label, 255, 255, 128)
	
	self.newMap2Label = guiCreateLabel(0.05, 0.4, 0.8, 0.2, "All available effects will be destroyed!", true, self.newMapWindow)
	guiLabelSetHorizontalAlign(self.newMap2Label, "left")
	guiLabelSetColor(self.newMap2Label, 255, 0, 0)
	
	self.newMapOKButton = guiCreateButton(0.05, 0.7, 0.265, 0.2, "OK", true, self.newMapWindow)
	self.newMapCancelButton = guiCreateButton(0.7, 0.7, 0.265, 0.2, "Cancel", true, self.newMapWindow)

	guiSetVisible(self.newMapWindow, false)
	-- ################# LOAD MAP WINDOW ################# --
	self.loadMapWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 100, 300, 200, "Load Map", false)
	
	self.loadMapGridList = guiCreateGridList(0.05, 0.15, 0.9, 0.65, true, self.loadMapWindow)
	self.loadMapGridListColumn = guiGridListAddColumn(self.loadMapGridList, "Avalailable Maps", 0.8)
	
	self.loadMapLoadButton = guiCreateButton(0.05, 0.85, 0.265, 0.1, "Load", true, self.loadMapWindow)
	self.loadMapDeleteButton = guiCreateButton(0.375, 0.85, 0.265, 0.1, "Delete", true, self.loadMapWindow)
	self.loadMapCancelButton = guiCreateButton(0.7, 0.85, 0.265, 0.1, "Cancel", true, self.loadMapWindow)

	guiSetVisible(self.loadMapWindow, false)
	-- ################# SAVE MAP WINDOW ################# --
	self.saveMapWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 50, 300, 100, "Save Map", false)
	
	self.saveMapLabel = guiCreateLabel(0.1, 0.2, 0.8, 0.2, "Choose name for your map:", true, self.saveMapWindow)
	guiLabelSetHorizontalAlign(self.saveMapLabel, "left")
	guiLabelSetColor(self.saveMapLabel, 255, 255, 0)
	
	self.saveMapEdit = guiCreateEdit(0.1, 0.4, 0.8, 0.2, "", true, self.saveMapWindow)
	guiEditSetMaxLength(self.saveMapEdit, 32)
	
	self.saveMapFinalButton = guiCreateButton (0.1, 0.7, 0.35, 0.2, "Save", true, self.saveMapWindow)
	self.saveMapCancelButton = guiCreateButton (0.55, 0.7, 0.35, 0.2, "Cancel", true, self.saveMapWindow)
	
	guiSetVisible(self.saveMapWindow, false)
	-- ################# Map already exist ################# --
	self.mapExistWindow = guiCreateWindow((self.screenWidth / 2) - 175, (self.screenHeight / 2) - 50, 350, 80, "Overwrite Map", false)
	
	self.mapExistLabel = guiCreateLabel(0.05, 0.3, 0.9, 0.2, "Are you sure to overwrite map: ", true, self.mapExistWindow)
	guiLabelSetHorizontalAlign(self.mapExistLabel, "left")
	guiLabelSetColor(self.mapExistLabel, 255, 0, 0)
	
	self.mapExistOKButton = guiCreateButton (0.1, 0.65, 0.35, 0.3, "OK", true, self.mapExistWindow)
	self.mapExistCancelButton = guiCreateButton (0.55, 0.65, 0.35, 0.3, "Cancel", true, self.mapExistWindow)
	
	guiSetVisible(self.mapExistWindow, false)
	
	-- ################# Really delete map ################# --
	self.reallyDeleteMapWindow = guiCreateWindow((self.screenWidth / 2) - 175, (self.screenHeight / 2) - 50, 350, 80, "Delete Map", false)
	
	self.reallyDeleteMapLabel = guiCreateLabel(0.05, 0.3, 0.9, 0.2, "Are you sure to delete map: ", true, self.reallyDeleteMapWindow)
	guiLabelSetHorizontalAlign(self.reallyDeleteMapLabel, "left")
	guiLabelSetColor(self.reallyDeleteMapLabel, 255, 0, 0)
	
	self.reallyDeleteMapOKButton = guiCreateButton (0.1, 0.65, 0.35, 0.3, "OK", true, self.reallyDeleteMapWindow)
	self.reallyDeleteMapCancelButton = guiCreateButton (0.55, 0.65, 0.35, 0.3, "Cancel", true, self.reallyDeleteMapWindow)
	
	guiSetVisible(self.reallyDeleteMapWindow, false)
	-- ################# EFFECT SETTINGS ################# --
	self.particelSettingsWindow = guiCreateWindow(0, 0, self.settingsPanelWidth, self.settingsPanelHeight, "Effect Settings", false)
	
	self.selectedEffectLabel = guiCreateLabel(0.1, 0.03, 0.8, 0.032, "'Nothing'", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.selectedEffectLabel, "center")
	
	self.previousEffectButton = guiCreateButton (0.05, 0.03, 0.12, 0.028, "<<",true, self.particelSettingsWindow)
	self.nextEffectButton = guiCreateButton (0.83, 0.03, 0.12, 0.028, ">>",true, self.particelSettingsWindow)
	
	self.lineLabel = guiCreateLabel(0.1, 0.045, 0.8, 0.032, "____________________________", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.lineLabel, "center")
	guiLabelSetColor(self.lineLabel, 255, 128, 55)
	
	self.loadPresetButton = guiCreateButton (0.05, 0.075, 0.4, 0.028, "Load...",true, self.particelSettingsWindow)
	self.savePresetButton = guiCreateButton (0.55, 0.075, 0.4, 0.028, "Save...",true, self.particelSettingsWindow)
	
	self.textureComboBox = guiCreateComboBox(0.1, 0.11, 0.8, 0.9, "Texture", true, self.particelSettingsWindow)
	guiComboBoxAddItem(self.textureComboBox, "smoke_A")
	guiComboBoxAddItem(self.textureComboBox, "smoke_B")
	guiComboBoxAddItem(self.textureComboBox, "smoke_C")
	guiComboBoxAddItem(self.textureComboBox, "smoke_D")
	guiComboBoxAddItem(self.textureComboBox, "dirt_A")
	guiComboBoxAddItem(self.textureComboBox, "dirt_B")
	guiComboBoxAddItem(self.textureComboBox, "dirt_C")
	guiComboBoxAddItem(self.textureComboBox, "colorDot_A")
	guiComboBoxAddItem(self.textureComboBox, "colorDot_B")
	guiComboBoxAddItem(self.textureComboBox, "colorDot_C")
	guiComboBoxAddItem(self.textureComboBox, "colorDot_D")
	guiComboBoxAddItem(self.textureComboBox, "colorDot_E")
	guiComboBoxAddItem(self.textureComboBox, "corona_A")
	guiComboBoxAddItem(self.textureComboBox, "corona_B")
	guiComboBoxAddItem(self.textureComboBox, "galaxy_A")
	guiComboBoxAddItem(self.textureComboBox, "galaxy_B")
	guiComboBoxAddItem(self.textureComboBox, "bubbles_A")
	guiComboBoxAddItem(self.textureComboBox, "bubbles_B")
	guiComboBoxAddItem(self.textureComboBox, "bubbles_C")
	guiComboBoxAddItem(self.textureComboBox, "anomaly_A")
	guiComboBoxAddItem(self.textureComboBox, "blood_A")
	guiComboBoxAddItem(self.textureComboBox, "leaf_A")
	guiComboBoxAddItem(self.textureComboBox, "fan_A")
	guiComboBoxAddItem(self.textureComboBox, "fan_B")
	guiComboBoxAddItem(self.textureComboBox, "fan_C")
	guiComboBoxAddItem(self.textureComboBox, "flashback_A")
	guiComboBoxAddItem(self.textureComboBox, "flashback_B")
	guiComboBoxAddItem(self.textureComboBox, "splash_A")
	guiComboBoxAddItem(self.textureComboBox, "glow_A")
	guiComboBoxAddItem(self.textureComboBox, "glow_B")
	
	guiComboBoxSetSelected(self.textureComboBox, 0)
	
	self.coordsXLabel = guiCreateLabel(0.1, 0.155, 0.1, 0.03, "X:", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.coordsXLabel, "left")
	guiLabelSetColor(self.coordsXLabel, 255, 255, 0)
	self.coordsXEdit = guiCreateEdit(0.22, 0.155, 0.68, 0.03, "0.000", true, self.particelSettingsWindow)
	guiEditSetMaxLength(self.coordsXEdit, 12)
	guiSetEnabled(self.coordsXEdit, false)
	
	self.coordsYLabel = guiCreateLabel(0.1, 0.185, 0.1, 0.03, "Y:", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.coordsYLabel, "left")
	guiLabelSetColor(self.coordsYLabel, 255, 255, 0)
	self.coordsYEdit = guiCreateEdit(0.22, 0.185, 0.68, 0.03, "0.000", true, self.particelSettingsWindow)
	guiEditSetMaxLength(self.coordsYEdit, 12)
	guiSetEnabled(self.coordsYEdit, false)
	
	self.coordsZLabel = guiCreateLabel(0.1, 0.215, 0.1, 0.03, "Z:", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.coordsZLabel, "left")
	guiLabelSetColor(self.coordsZLabel, 255, 255, 0)
	self.coordsZEdit = guiCreateEdit(0.22, 0.215, 0.68, 0.03, "0.000", true, self.particelSettingsWindow)
	guiEditSetMaxLength(self.coordsZEdit, 12)
	guiSetEnabled(self.coordsZEdit, false)
	
	self.maxParticleLabel = guiCreateLabel(0.1, 0.25, 0.8, 0.032, "Max Particles: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.maxParticleLabel, "center")
	guiLabelSetColor(self.maxParticleLabel, 255, 255, 0)
	
	self.maxParticlesScrollBar = guiCreateScrollBar(0.1, 0.28, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.maxParticlesValue = (100/self.maxParticlesCount) * self.maxParticles
	guiScrollBarSetScrollPosition(self.maxParticlesScrollBar, self.maxParticlesValue)
	guiSetText(self.maxParticleLabel, "Max Particles: " .. self.maxParticles)
	
	self.radiusLabel = guiCreateLabel(0.1, 0.305, 0.8, 0.032, "Radius: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.radiusLabel, "center")
	guiLabelSetColor(self.radiusLabel, 255, 255, 0)
	
	self.radiusScrollBar = guiCreateScrollBar(0.1, 0.335, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.radiusValue = (100/self.maxRadiusValue) * self.radius
	guiScrollBarSetScrollPosition(self.radiusScrollBar, self.radiusValue)
	guiSetText(self.radiusLabel, "Radius: " .. self.radius)
	
	self.turbulenceLabel = guiCreateLabel(0.1, 0.36, 0.8, 0.032, "Turbulence: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.turbulenceLabel, "center")
	guiLabelSetColor(self.turbulenceLabel, 255, 255, 0)
	
	self.turbulenceScrollBar = guiCreateScrollBar(0.1, 0.39, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.turbulenceValue = (100/self.maxTurbulenceValue) * self.turbulence
	guiScrollBarSetScrollPosition(self.turbulenceScrollBar, self.turbulenceValue)
	guiSetText(self.turbulenceLabel, "Turbulence: " .. self.turbulence)
	
	self.velocityXLabel = guiCreateLabel(0.1, 0.415, 0.8, 0.032, "Velocity X: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.velocityXLabel, "center")
	guiLabelSetColor(self.velocityXLabel, 255, 255, 0)
	
	self.velocityXScrollBar = guiCreateScrollBar(0.1, 0.445, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.velocityXValue = (100/self.maxVelocityXValue) * self.velocityX
	guiScrollBarSetScrollPosition(self.velocityXScrollBar, self.velocityXValue)
	guiSetText(self.velocityXLabel, "Velocity X: " .. self.velocityX)
	
	self.velocityYLabel = guiCreateLabel(0.1, 0.47, 0.8, 0.032, "Velocity Y: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.velocityYLabel, "center")
	guiLabelSetColor(self.velocityYLabel, 255, 255, 0)
	
	self.velocityYScrollBar = guiCreateScrollBar(0.1, 0.5, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.velocityYValue = (100/self.maxVelocityYValue) * self.velocityY
	guiScrollBarSetScrollPosition(self.velocityYScrollBar, self.velocityYValue)
	guiSetText(self.velocityYLabel, "Velocity Y: " .. self.velocityY)
	
	self.velocityZLabel = guiCreateLabel(0.1, 0.525, 0.8, 0.032, "Velocity Z: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.velocityZLabel, "center")
	guiLabelSetColor(self.velocityZLabel, 255, 255, 0)
	
	self.velocityZScrollBar = guiCreateScrollBar(0.1, 0.555, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.velocityZValue = (100/self.maxVelocityZValue) * self.velocityZ
	guiScrollBarSetScrollPosition(self.velocityZScrollBar, self.velocityZValue)
	guiSetText(self.velocityZLabel, "Velocity Z: " .. self.velocityZ)
	
	self.effectRotationLabel = guiCreateLabel(0.1, 0.58, 0.8, 0.032, "Effect Rotation: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.effectRotationLabel, "center")
	guiLabelSetColor(self.effectRotationLabel, 255, 255, 0)
	
	self.effectRotationScrollBar = guiCreateScrollBar(0.1, 0.61, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.effectRotationValue = (100/self.maxRotationValue) * self.effectRotation
	guiScrollBarSetScrollPosition(self.effectRotationScrollBar, self.effectRotationValue)
	guiSetText(self.effectRotationLabel, "Rotation: " .. self.effectRotation)
	
	self.startParticleSizeLabel = guiCreateLabel(0.1, 0.635, 0.8, 0.032, "Particle Start Size: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.startParticleSizeLabel, "center")
	guiLabelSetColor(self.startParticleSizeLabel, 255, 255, 0)
	
	self.startParticleSizeScrollBar = guiCreateScrollBar(0.1, 0.665, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.startParticleSizeValue = (100/self.maxStartSizeValue) * self.startParticleSize
	guiScrollBarSetScrollPosition(self.startParticleSizeScrollBar, self.startParticleSizeValue)
	guiSetText(self.startParticleSizeLabel, "Particle Start Size: " .. self.startParticleSize)
	
	self.endParticleSizeLabel = guiCreateLabel(0.1, 0.695, 0.8, 0.032, "Particle End Size: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.endParticleSizeLabel, "center")
	guiLabelSetColor(self.endParticleSizeLabel, 255, 255, 0)
	
	self.endParticleSizeScrollBar = guiCreateScrollBar(0.1, 0.725, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.endParticleSizeValue = (100/self.maxEndSizeValue) * self.endParticleSize
	guiScrollBarSetScrollPosition(self.endParticleSizeScrollBar, self.endParticleSizeValue)
	guiSetText(self.endParticleSizeLabel, "Particle End Size: " .. self.endParticleSize)

	self.particleLifeTimeLabel = guiCreateLabel(0.1, 0.75, 0.8, 0.032, "Particle Lifetime: 0 (ms)", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.particleLifeTimeLabel, "center")
	guiLabelSetColor(self.particleLifeTimeLabel, 255, 255, 0)
	
	self.particleLifeTimeScrollBar = guiCreateScrollBar(0.1, 0.78, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.particleLifeTimeValue = (100/self.maxLifeTimeValue) * self.particleLifeTime
	guiScrollBarSetScrollPosition(self.particleLifeTimeScrollBar, self.particleLifeTimeValue)
	guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: " .. self.particleLifeTime .. " (ms)")

	self.brightnessLabel = guiCreateLabel(0.1, 0.805, 0.8, 0.032, "Brightness: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.brightnessLabel, "center")
	guiLabelSetColor(self.brightnessLabel, 255, 255, 0)
	
	self.brightnessScrollBar = guiCreateScrollBar(0.1, 0.835, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.brightnessValue = (100/self.maxBrightnessValue) * self.brightness
	guiScrollBarSetScrollPosition(self.brightnessScrollBar, self.brightnessValue)
	guiSetText(self.brightnessLabel, "Brightness: " .. self.brightness)
	
	self.alphaLabel = guiCreateLabel(0.1, 0.86, 0.8, 0.032, "Alpha: 0", true, self.particelSettingsWindow)
	guiLabelSetHorizontalAlign(self.alphaLabel, "center")
	guiLabelSetColor(self.alphaLabel, 255, 255, 0)
	
	self.alphaScrollBar = guiCreateScrollBar(0.1, 0.89, 0.8, 0.02, true, true, self.particelSettingsWindow)
	self.alphaValue = (100/self.maxAlphaValue) * self.alpha
	guiScrollBarSetScrollPosition(self.alphaScrollBar, self.alphaValue)
	guiSetText(self.alphaLabel, "Alpha: " .. self.alpha)
	
	self.isRainBowColorsCheckBox = guiCreateCheckBox(0.1, 0.92, 0.6, 0.03, "Rainbow Colors", false, true, self.particelSettingsWindow)
	self.changeColorButton = guiCreateButton (0.1, 0.96, 0.8, 0.035, "Change Color...", true, self.particelSettingsWindow)
	guiSetEnabled(self.changeColorButton, false)
	
	guiWindowSetSizable(self.particelSettingsWindow, false)
	guiSetVisible(self.particelSettingsWindow, false)
	
	-- ################# Load Presets ################# --
	self.loadPresetWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 100, 300, 200, "Load Preset", false)
	
	self.loadPresetGridList = guiCreateGridList(0.05, 0.15, 0.9, 0.65, true, self.loadPresetWindow)
	self.loadPresetGridListColumn = guiGridListAddColumn(self.loadPresetGridList, "Avalailable Presets", 0.8)
	
	self.loadPresetLoadButton = guiCreateButton(0.05, 0.85, 0.265, 0.1, "Load", true, self.loadPresetWindow)
	self.loadPresetDeleteButton = guiCreateButton(0.375, 0.85, 0.265, 0.1, "Delete", true, self.loadPresetWindow)
	self.loadPresetCancelButton = guiCreateButton(0.7, 0.85, 0.265, 0.1, "Cancel", true, self.loadPresetWindow)

	guiSetVisible(self.loadPresetWindow, false)
	-- ################# Save Presets ################# --
	self.savePresetWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 50, 300, 100, "Save Preset", false)
	
	self.savePresetLabel = guiCreateLabel(0.1, 0.2, 0.8, 0.2, "Choose name for your preset:", true, self.savePresetWindow)
	guiLabelSetHorizontalAlign(self.savePresetLabel, "left")
	guiLabelSetColor(self.savePresetLabel, 255, 255, 0)
	
	self.savePresetEdit = guiCreateEdit(0.1, 0.4, 0.8, 0.2, "", true, self.savePresetWindow)
	guiEditSetMaxLength(self.savePresetEdit, 32)
	
	self.savePresetFinalButton = guiCreateButton (0.1, 0.7, 0.35, 0.2, "Save", true, self.savePresetWindow)
	self.savePresetCancelButton = guiCreateButton (0.55, 0.7, 0.35, 0.2, "Cancel", true, self.savePresetWindow)
	
	guiSetVisible(self.savePresetWindow, false)
	
	-- ################# Preset already exist ################# --
	self.presetExistWindow = guiCreateWindow((self.screenWidth / 2) - 175, (self.screenHeight / 2) - 50, 350, 80, "Overwrite Preset", false)
	
	self.presetExistLabel = guiCreateLabel(0.05, 0.3, 0.9, 0.2, "Are you sure to overwrite preset: ", true, self.presetExistWindow)
	guiLabelSetHorizontalAlign(self.presetExistLabel, "left")
	guiLabelSetColor(self.presetExistLabel, 255, 0, 0)
	
	self.presetExistOKButton = guiCreateButton (0.1, 0.65, 0.35, 0.3, "OK", true, self.presetExistWindow)
	self.presetExistCancelButton = guiCreateButton (0.55, 0.65, 0.35, 0.3, "Cancel", true, self.presetExistWindow)
	
	guiSetVisible(self.presetExistWindow, false)
	
	-- ################# Really delete preset ################# --
	self.reallyDeletePresetWindow = guiCreateWindow((self.screenWidth / 2) - 175, (self.screenHeight / 2) - 50, 350, 80, "Delete Preset", false)
	
	self.reallyDeletePresetLabel = guiCreateLabel(0.05, 0.3, 0.9, 0.2, "Are you sure to delete preset: ", true, self.reallyDeletePresetWindow)
	guiLabelSetHorizontalAlign(self.reallyDeletePresetLabel, "left")
	guiLabelSetColor(self.reallyDeletePresetLabel, 255, 0, 0)
	
	self.reallyDeletePresetOKButton = guiCreateButton (0.1, 0.65, 0.35, 0.3, "OK", true, self.reallyDeletePresetWindow)
	self.reallyDeletePresetCancelButton = guiCreateButton (0.55, 0.65, 0.35, 0.3, "Cancel", true, self.reallyDeletePresetWindow)
	
	guiSetVisible(self.reallyDeletePresetWindow, false)
	
	-- ################# Change Color ################# --
	self.changeColorWindow = guiCreateWindow((self.screenWidth / 2) - 150, (self.screenHeight / 2) - 100, 300, 200, "Change Color", false)
	
	guiSetVisible(self.changeColorWindow, false)
	
	-- ################# Events & Bindings ################# --
	
	self.m_ToggleEditorGUI = function() self:toggleEditorGUI() end
	bindKey("F3", "down", self.m_ToggleEditorGUI)
	
	self.m_OnParticleEffectSelected = function(...) self:onParticleEffectSelected(...) end
	addEvent("onParticleEffectSelected", true)
	addEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	
	self.m_OnParticleEffectDeSelected = function() self:onParticleEffectDeSelected() end
	addEvent("onParticleEffectDeSelected", true)
	addEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	
	self.m_OnPresetAlreadyExist = function(...) self:onPresetAlreadyExist(...) end
	addEvent("onPresetAlreadyExist", true)
	addEventHandler("onPresetAlreadyExist", root, self.m_OnPresetAlreadyExist)
	
	self.m_OnClientGUIClick = function() self:onClientGUIClick() end
	addEventHandler("onClientGUIClick", root, self.m_OnClientGUIClick)
	
	self.m_OnClientGUIFocus = function() self:onClientGUIFocus() end
	addEventHandler("onClientGUIFocus", root, self.m_OnClientGUIFocus, true)
	
	self.m_PresetListRefreshed = function(...) self:presetListRefreshed(...) end
	addEvent("presetListRefreshed", true)
	addEventHandler("presetListRefreshed", root, self.m_PresetListRefreshed)
	
	self.m_OnPresetWasLoaded = function(...) self:onPresetWasLoaded(...) end
	addEvent("onPresetWasLoaded", true)
	addEventHandler("onPresetWasLoaded", root, self.m_OnPresetWasLoaded)
	
	self.m_OnMapAlreadyExist = function(...) self:onMapAlreadyExist(...) end
	addEvent("onMapAlreadyExist", true)
	addEventHandler("onMapAlreadyExist", root, self.m_OnMapAlreadyExist)
	
	self.m_OnMapListRefreshed = function(...) self:onMapListRefreshed(...) end
	addEvent("onMapListRefreshed", true)
	addEventHandler("onMapListRefreshed", root, self.m_OnMapListRefreshed)

	self.m_RefreshMapGridList = function(...) self:refreshMapGridList(...) end
	addEvent("refreshMapGridList", true)
	addEventHandler("refreshMapGridList", root, self.m_RefreshMapGridList)
	
	mainOutput("EditorGUIClassC was started...")
end


function EditorGUIClassC:toggleEditorGUI()
	if (guiGetVisible(self.particelSettingsWindow) == false) then
		if (self.selectedEffect) then
			guiSetVisible(self.particelSettingsWindow, true)
		end
	elseif (guiGetVisible(self.particelSettingsWindow) == true) then
		guiSetVisible(self.particelSettingsWindow, false)
		self.selectedGUIElement = nil
	end
end


function EditorGUIClassC:onPresetAlreadyExist(presetID)
	if (presetID) then
		guiSetText(self.presetExistLabel, "Are you sure to overwrite preset: " .. tostring(presetID))
		guiSetVisible(self.savePresetWindow, true)
		guiSetVisible(self.presetExistWindow, true)
		guiBringToFront(self.presetExistWindow)
	end
end


function EditorGUIClassC:onMapAlreadyExist(mapName)
	if (mapName) then
		guiSetText(self.mapExistLabel, "Are you sure to overwrite map: " .. tostring(mapName))
		guiSetVisible(self.saveMapWindow, true)
		guiSetVisible(self.mapExistWindow, true)
		guiBringToFront(self.mapExistWindow)
	end
end


function EditorGUIClassC:onMapListRefreshed(mapList)
	if (mapList) then
		self.mapList = mapList
	end
end


function EditorGUIClassC:onClientGUIClick()
	if (source == self.previousEffectButton) then
		self.selectedGUIElement = self.previousEffectButton
		
		if (self.selectedEffect) then	
			if (self.selectedEffect.id) then
				local effectTable = getElementsByType("xrParticleEffect")
				
				for index, effectElement in ipairs(effectTable) do
					if (self.selectedEffect.id == effectElement.id) then
						local index = index
						
						if ((index - 1) >= 0) then
							if (effectTable[index - 1]) then
								triggerEvent("onParticleEffectSelected", root, effectTable[index - 1])
							end
						end
						
						break
					end
				end
			end
		end
	elseif (source == self.nextEffectButton) then 
		
		self.selectedGUIElement = self.nextEffectButton
		
		if (self.selectedEffect) then	
			if (self.selectedEffect.id) then
				local effectTable = getElementsByType("xrParticleEffect")
				local maxEffects = #getElementsByType("xrParticleEffect")
				
				for index, effectElement in ipairs(effectTable) do
					if (self.selectedEffect.id == effectElement.id) then
						local index = index
						
						if ((index + 1) <= maxEffects) then
							if (effectTable[index + 1]) then
								triggerEvent("onParticleEffectSelected", root, effectTable[index + 1])
							end
						end
						
						break
					end
				end
			end
		end
	elseif (source == self.textureComboBox) then 
		self.selectedGUIElement = self.textureComboBox
	elseif (source == self.coordsXEdit) then 
		self.selectedGUIElement = self.coordsXEdit
	elseif (source == self.coordsYEdit) then 
		self.selectedGUIElement = self.coordsYEdit
	elseif (source == self.coordsZEdit) then 
		self.selectedGUIElement = self.coordsZEdit
	elseif (source == self.maxParticlesScrollBar) then
		self.selectedGUIElement = self.maxParticlesScrollBar
	elseif (source == self.radiusScrollBar) then
		self.selectedGUIElement = self.radiusScrollBar
	elseif (source == self.turbulenceScrollBar) then
		self.selectedGUIElement = self.turbulenceScrollBar
	elseif (source == self.velocityXScrollBar) then
		self.selectedGUIElement = self.velocityXScrollBar
	elseif (source == self.velocityYScrollBar) then
		self.selectedGUIElement = self.velocityYScrollBar
	elseif (source == self.velocityZScrollBar) then
		self.selectedGUIElement = self.velocityZScrollBar
	elseif (source == self.effectRotationScrollBar) then
		self.selectedGUIElement = self.effectRotationScrollBar
	elseif (source == self.startParticleSizeScrollBar) then
		self.selectedGUIElement = self.startParticleSizeScrollBar
	elseif (source == self.endParticleSizeScrollBar) then
		self.selectedGUIElement = self.endParticleSizeScrollBar
	elseif (source == self.particleLifeTimeScrollBar) then
		self.selectedGUIElement = self.particleLifeTimeScrollBar
	elseif (source == self.brightnessScrollBar) then
		self.selectedGUIElement = self.brightnessScrollBar
	elseif (source == self.alphaScrollBar) then
		self.selectedGUIElement = self.alphaScrollBar
	elseif (source == self.isRainBowColorsCheckBox) then
		self.selectedGUIElement = self.isRainBowColorsCheckBox
		
		if (guiCheckBoxGetSelected(self.isRainBowColorsCheckBox) == true) then
			guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, false)
			self.isRainBowColors = "false"
		elseif (guiCheckBoxGetSelected(self.isRainBowColorsCheckBox) == false) then
			guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, true)
			self.isRainBowColors = "true"
		end
		
		triggerEvent("onRainbowColorChanged", root, self.selectedEffect.id, self.isRainBowColors)
	elseif (source == self.changeColorButton) then
		self.selectedGUIElement = self.changeColorButton
	elseif (source == self.loadPresetButton) then
		self.selectedGUIElement = self.loadPresetButton
		triggerEvent("onPresetListRequested", root)
		guiSetVisible(self.loadPresetWindow, true)
	elseif (source == self.loadPresetLoadButton) then
		self.selectedGUIElement = self.loadPresetLoadButton
		local preset = guiGridListGetItemText(self.loadPresetGridList, guiGridListGetSelectedItem(self.loadPresetGridList), 1)
		if (preset) then
			triggerEvent("loadPreset", root, preset)
		end
		guiSetVisible(self.loadPresetWindow, false)
	elseif (source == self.loadPresetDeleteButton) then
		self.selectedGUIElement = self.loadPresetDeleteButton
		local preset = guiGridListGetItemText(self.loadPresetGridList, guiGridListGetSelectedItem(self.loadPresetGridList), 1)
		if (preset) then
			guiSetText(self.reallyDeletePresetLabel, "Are you sure to delete preset: " .. preset)
		end
		guiSetVisible(self.reallyDeletePresetWindow, true)
		guiBringToFront(self.reallyDeletePresetWindow)
	elseif (source == self.reallyDeletePresetOKButton) then
		self.selectedGUIElement = self.reallyDeletePresetOKButton
		local preset = guiGridListGetItemText(self.loadPresetGridList, guiGridListGetSelectedItem(self.loadPresetGridList), 1)
		if (preset) then
			triggerEvent("onPresetDelete", root, preset)
		end
		guiSetVisible(self.reallyDeletePresetWindow, false)
	elseif (source == self.reallyDeletePresetCancelButton) then
		self.selectedGUIElement = self.reallyDeletePresetCancelButton
		guiSetVisible(self.reallyDeletePresetWindow, false)
	elseif (source == self.loadPresetCancelButton) then
		self.selectedGUIElement = self.loadPresetCancelButton
		guiSetVisible(self.loadPresetWindow, false)
	elseif (source == self.savePresetEdit) then
		self.selectedGUIElement = self.savePresetEdit
	elseif (source == self.savePresetButton) then
		self.selectedGUIElement = self.savePresetButton
		guiSetText(self.savePresetEdit, self.selectedEffect.id)
		guiSetVisible(self.savePresetWindow, true)
	elseif (source == self.savePresetFinalButton) then
		self.selectedGUIElement = self.savePresetButton
		if (self.selectedEffect) then
			local presetName = guiGetText(self.savePresetEdit)
			triggerEvent("savePreset", root, presetName, self.selectedEffect)
			guiSetVisible(self.savePresetWindow, false)
		end
	elseif (source == self.savePresetCancelButton) then
		self.selectedGUIElement = self.savePresetButton
		guiSetVisible(self.savePresetWindow, false)
	elseif (source == self.presetExistOKButton) then
		self.selectedGUIElement = self.presetExistOKButton
		guiSetText(self.presetExistLabel, "Are you sure to overwrite preset: ")
		guiLabelSetColor(self.presetExistLabel, 255, 0, 0)
		guiSetVisible(self.presetExistWindow, false)
		if (self.selectedEffect) then
			local presetName = guiGetText(self.savePresetEdit)
			triggerEvent("doSavePreset", root, presetName, self.selectedEffect)
			guiSetVisible(self.presetExistWindow, false)
			guiSetVisible(self.savePresetWindow, false)
		end
	elseif (source == self.presetExistCancelButton) then
		self.selectedGUIElement = self.presetExistCancelButton
		guiSetText(self.presetExistLabel, "Are you sure to overwrite preset: ")
		guiLabelSetColor(self.presetExistLabel, 255, 0, 0)
		guiSetVisible(self.presetExistWindow, false)
		guiSetVisible(self.savePresetWindow, true)
	elseif (source == self.newMapButton) then
		self.selectedGUIElement = self.newMapButton
		guiSetVisible(self.newMapWindow, true)
		guiBringToFront(self.newMapWindow)
	elseif (source == self.newMapOKButton) then
		self.selectedGUIElement = self.newMapOKButton
		guiSetVisible(self.newMapWindow, false)
		triggerServerEvent("resetCompleteMap", root)
	elseif (source == self.newMapCancelButton) then
		self.selectedGUIElement = self.newMapCancelButton
		guiSetVisible(self.newMapWindow, false)
	elseif (source == self.loadMapButton) then
		self.selectedGUIElement = self.loadMapButton
		self:refreshMapGridList()
		guiSetVisible(self.loadMapWindow, true)
		guiBringToFront(self.loadMapWindow)
	elseif (source == self.loadMapLoadButton) then
		self.selectedGUIElement = self.loadMapLoadButton

		local mapName = guiGridListGetItemText(self.loadMapGridList, guiGridListGetSelectedItem(self.loadMapGridList), 1)
		
		if (mapName) then
			triggerServerEvent("loadEffectMap", root, mapName)
		end
		guiSetVisible(self.loadMapWindow, false)
	elseif (source == self.loadMapDeleteButton) then
		local mapName = guiGridListGetItemText(self.loadMapGridList, guiGridListGetSelectedItem(self.loadMapGridList), 1)
		
		if (mapName) then
			guiSetText(self.reallyDeleteMapLabel, "Are you sure to delete map: " .. mapName)
		end
		
		guiSetVisible(self.reallyDeleteMapWindow, true)
		guiBringToFront(self.reallyDeleteMapWindow)
	elseif (source == self.reallyDeleteMapOKButton) then
		self.selectedGUIElement = self.reallyDeleteMapOKButton
		
		local mapName = guiGridListGetItemText(self.loadMapGridList, guiGridListGetSelectedItem(self.loadMapGridList), 1)
		
		if (mapName) then
			triggerServerEvent("deleteEffectMap", root, mapName)
		end
		
		guiSetVisible(self.reallyDeleteMapWindow, false)
		self:refreshMapGridList()
	elseif (source == self.reallyDeleteMapCancelButton) then
		self.selectedGUIElement = self.reallyDeleteMapCancelButton
		guiSetVisible(self.reallyDeleteMapWindow, false)
	elseif (source == self.loadMapCancelButton) then
		self.selectedGUIElement = self.loadMapCancelButton
		guiSetVisible(self.loadMapWindow, false)
	elseif (source == self.saveMapEdit) then
		self.selectedGUIElement = self.saveMapEdit	
	elseif (source == self.saveMapButton) then
		self.selectedGUIElement = self.saveMapButton	
		guiSetVisible(self.saveMapWindow, true)
		guiBringToFront(self.saveMapWindow)
	elseif (source == self.saveMapFinalButton) then
		self.selectedGUIElement = self.saveMapFinalButton
		triggerServerEvent("saveEffectMap", root, guiGetText(self.saveMapEdit), false)
		guiSetVisible(self.saveMapWindow, false)
	elseif (source == self.saveMapCancelButton) then
		self.selectedGUIElement = self.saveMapCancelButton
		guiSetVisible(self.saveMapWindow, false)
	elseif (source == self.mapExistOKButton) then
		self.selectedGUIElement = self.mapExistOKButton
		triggerServerEvent("saveEffectMap", root, guiGetText(self.saveMapEdit), true)
		guiSetVisible(self.saveMapWindow, false)
		guiSetVisible(self.mapExistWindow, false)
	elseif (source == self.mapExistCancelButton) then
		self.selectedGUIElement = self.mapExistCancelButton
		guiSetVisible(self.saveMapWindow, true)
		guiBringToFront(self.saveMapWindow)
		guiSetVisible(self.mapExistWindow, false)
	end
end


function EditorGUIClassC:presetListRefreshed(presetList)
	if (presetList) then
		self.presetList = presetList
		
		guiGridListClear(self.loadPresetGridList)
		
		for index, preset in pairs(self.presetList) do
			if (preset) then
				local row = guiGridListAddRow(self.loadPresetGridList)
                guiGridListSetItemText(self.loadPresetGridList, row, self.loadPresetGridListColumn, tostring(preset), false, false)
			end
		end
	end
end


function EditorGUIClassC:refreshMapGridList()
	guiGridListClear(self.loadMapGridList)
	
	for index, map in pairs(self.mapList) do
		if (map) then
			local row = guiGridListAddRow(self.loadMapGridList)
			guiGridListSetItemText(self.loadMapGridList, row, self.loadMapGridListColumn, tostring(map), false, false)
		end
	end
end


function EditorGUIClassC:update()
	if (guiGetVisible(self.particelSettingsWindow) == true) then
		if (self.selectedEffect) and (isElement(self.selectedEffect)) then
		
			guiSetEnabled (self.savePresetButton, true)
			
			self.x = self.selectedEffect:getData("x")
			self.y = self.selectedEffect:getData("y")
			self.z = self.selectedEffect:getData("z")
			
			guiSetText(self.coordsXEdit, self.x)
			guiSetText(self.coordsYEdit, self.y)
			guiSetText(self.coordsZEdit, self.z)
			
			if (self.selectedGUIElement) then
				guiSetInputMode("allow_binds")
				
				if (self.selectedGUIElement == self.textureComboBox) then
					local item = guiComboBoxGetSelected(self.textureComboBox)
					local texture = guiComboBoxGetItemText(self.textureComboBox, item)
					
					if (texture) then
						triggerEvent("onTextureChanged", root, self.selectedEffect.id, texture)
						self.texture = texture
					end
				elseif (self.selectedGUIElement == self.maxParticlesScrollBar) then
					self.maxParticlesValue = math.round((self.maxParticlesCount/100) * guiScrollBarGetScrollPosition(self.maxParticlesScrollBar), 0)
					guiSetText(self.maxParticleLabel, "Max Particles: " .. self.maxParticlesValue)
					
					triggerEvent("onMaxParticlesChanged", root, self.selectedEffect.id, self.maxParticlesValue)
					self.maxParticles = self.maxParticlesValue
				elseif (self.selectedGUIElement == self.radiusScrollBar) then
					self.radiusValue = math.round((self.maxRadiusValue/100) * guiScrollBarGetScrollPosition(self.radiusScrollBar), 2)
					guiSetText(self.radiusLabel, "Radius: " .. self.radiusValue)
					
					triggerEvent("onRadiusChanged", root, self.selectedEffect.id, self.radiusValue)
					self.radius = self.radiusValue
				elseif (self.selectedGUIElement == self.turbulenceScrollBar) then
					self.turbulenceValue = math.round((self.maxTurbulenceValue/100) * guiScrollBarGetScrollPosition(self.turbulenceScrollBar), 2)
					guiSetText(self.turbulenceLabel, "Turbulence: " .. self.turbulenceValue)
					
					triggerEvent("onTurbulenceChanged", root, self.selectedEffect.id, self.turbulenceValue)
					self.turbulence = self.turbulenceValue
				elseif (self.selectedGUIElement == self.velocityXScrollBar) then
					self.velocityXValue = math.round((self.maxVelocityXValue/100) * guiScrollBarGetScrollPosition(self.velocityXScrollBar), 2)
					guiSetText(self.velocityXLabel, "Velocity X: " .. self.velocityXValue)
					
					triggerEvent("onVelocityXChanged", root, self.selectedEffect.id, self.velocityXValue)
					self.velocityX = self.velocityXValue
				elseif (self.selectedGUIElement == self.velocityYScrollBar) then
					self.velocityYValue = math.round((self.maxVelocityYValue/100) * guiScrollBarGetScrollPosition(self.velocityYScrollBar), 2)
					guiSetText(self.velocityYLabel, "Velocity Y: " .. self.velocityYValue)
					
					triggerEvent("onVelocityYChanged", root, self.selectedEffect.id, self.velocityYValue)
					self.velocityY = self.velocityYValue
				elseif (self.selectedGUIElement == self.velocityZScrollBar) then
					self.velocityZValue = math.round((self.maxVelocityZValue/100) * guiScrollBarGetScrollPosition(self.velocityZScrollBar), 2)
					guiSetText(self.velocityZLabel, "Velocity Z: " .. self.velocityZValue)
					
					triggerEvent("onVelocityZChanged", root, self.selectedEffect.id, self.velocityZValue)
					self.velocityZ = self.velocityZValue
				elseif (self.selectedGUIElement == self.effectRotationScrollBar) then
					self.effectRotationValue = math.round((self.maxRotationValue/100) * guiScrollBarGetScrollPosition(self.effectRotationScrollBar), 2)
					guiSetText(self.effectRotationLabel, "Rotation: " .. self.effectRotationValue)
					
					triggerEvent("onEffectRotationChanged", root, self.selectedEffect.id, self.effectRotationValue)
					self.effectRotation = self.effectRotationValue
				elseif (self.selectedGUIElement == self.startParticleSizeScrollBar) then
					self.startParticleSizeValue = math.round((self.maxStartSizeValue/100) * guiScrollBarGetScrollPosition(self.startParticleSizeScrollBar), 2)
					guiSetText(self.startParticleSizeLabel, "Particle Start Size: " .. self.startParticleSizeValue)
					
					triggerEvent("onStartParticleSizeChanged", root, self.selectedEffect.id, self.startParticleSizeValue)
					self.startParticleSize = self.startParticleSizeValue
				elseif (self.selectedGUIElement == self.endParticleSizeScrollBar) then
					self.endParticleSizeValue = math.round((self.maxEndSizeValue/100) * guiScrollBarGetScrollPosition(self.endParticleSizeScrollBar), 2)
					guiSetText(self.endParticleSizeLabel, "Particle End Size: " .. self.endParticleSizeValue)
					
					triggerEvent("onEndParticleSizeChanged", root, self.selectedEffect.id, self.endParticleSizeValue)
					self.endParticleSize = self.endParticleSizeValue
				elseif (self.selectedGUIElement == self.particleLifeTimeScrollBar) then
					self.particleLifeTimeValue = math.round((self.maxLifeTimeValue/100) * guiScrollBarGetScrollPosition(self.particleLifeTimeScrollBar), 0)
					
					if (self.particleLifeTimeValue <= 50) then
						self.particleLifeTimeValue = 50
					elseif (self.particleLifeTimeValue > 35000) then
						self.particleLifeTimeValue = self.maxLifeTimeValue
					end
					
					
					if (self.particleLifeTimeValue == self.maxLifeTimeValue) then
						guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: permanent")
					else
						guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: " .. self.particleLifeTimeValue .. " (ms)")
					end
					
					triggerEvent("onLifeTimeChanged", root, self.selectedEffect.id, self.particleLifeTimeValue)
					self.particleLifeTime = self.particleLifeTimeValue
				elseif (self.selectedGUIElement == self.brightnessScrollBar) then
					self.brightnessValue = math.round((self.maxBrightnessValue/100) * guiScrollBarGetScrollPosition(self.brightnessScrollBar), 2)
					guiSetText(self.brightnessLabel, "Brightness: " .. self.brightnessValue)
					
					triggerEvent("onBrightnessChanged", root, self.selectedEffect.id, self.brightnessValue)
					self.brightness = self.brightnessValue
				elseif (self.selectedGUIElement == self.alphaScrollBar) then
					self.alphaValue = math.round((self.maxAlphaValue/100) * guiScrollBarGetScrollPosition(self.alphaScrollBar), 1)
					guiSetText(self.alphaLabel, "Alpha: " .. self.alphaValue)
					
					triggerEvent("onAlphaChanged", root, self.selectedEffect.id, self.alphaValue)
					self.alpha = self.alphaValue
				elseif (self.selectedGUIElement == self.savePresetEdit) then
					guiSetInputMode("no_binds_when_editing")
				elseif (self.selectedGUIElement == self.saveMapEdit) then
					guiSetInputMode("no_binds_when_editing")
				end			
			end
		else
			guiSetEnabled(self.savePresetButton, false)
			
			guiSetText(self.coordsXEdit, "0.000")
			guiSetText(self.coordsYEdit, "0.000")
			guiSetText(self.coordsZEdit, "0.000")

			guiScrollBarSetScrollPosition(self.maxParticlesScrollBar, 0)
			guiSetText(self.maxParticleLabel, "Max Particles: " .. 0)
			guiScrollBarSetScrollPosition(self.radiusScrollBar, 0)
			guiSetText(self.radiusLabel, "Radius: " .. 0)
			guiScrollBarSetScrollPosition(self.turbulenceScrollBar, 0)
			guiSetText(self.turbulenceLabel, "Turbulence: " .. 0)
			guiScrollBarSetScrollPosition(self.velocityXScrollBar, 0)
			guiSetText(self.velocityXLabel, "Velocity X: " .. 0)
			guiScrollBarSetScrollPosition(self.velocityYScrollBar, 0)
			guiSetText(self.velocityYLabel, "Velocity Y: " .. 0)
			guiScrollBarSetScrollPosition(self.velocityZScrollBar, 0)
			guiSetText(self.velocityZLabel, "Velocity Z: " .. 0)
			guiScrollBarSetScrollPosition(self.effectRotationScrollBar, 0)
			guiSetText(self.effectRotationLabel, "Effect Rotation: " .. 0)
			guiScrollBarSetScrollPosition(self.startParticleSizeScrollBar, 0)
			guiSetText(self.startParticleSizeLabel, "Particle Start Size: " .. 0)
			guiScrollBarSetScrollPosition(self.endParticleSizeScrollBar, 0)
			guiSetText(self.endParticleSizeLabel, "Particle End Size: " .. 0)
			guiScrollBarSetScrollPosition(self.particleLifeTimeScrollBar, 0)
			guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: 0 (ms)")
			guiScrollBarSetScrollPosition(self.alphaScrollBar, 0)
			guiSetText(self.alphaLabel, "Alpha: " .. 0)
			guiScrollBarSetScrollPosition(self.brightnessScrollBar, 0)
			guiSetText(self.brightnessLabel, "Brightness: " .. 0)
			guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, false)
		end
		
		if (guiGridListGetRowCount(self.loadPresetGridList) < 1) then
			guiSetEnabled(self.loadPresetLoadButton, false)
			guiSetEnabled(self.loadPresetDeleteButton, false)
		else
			guiSetEnabled(self.loadPresetLoadButton, true)
			guiSetEnabled(self.loadPresetDeleteButton, true)
		end
	end
	
	if (self.selectedGUIElement == self.saveMapEdit) then
		guiSetInputMode("no_binds_when_editing")
	end	
	
	if (guiGridListGetRowCount(self.loadMapGridList) < 1) or (#self.mapList < 1) then
		guiSetEnabled(self.loadMapLoadButton, false)
		guiSetEnabled(self.loadMapDeleteButton, false)
	else
		guiSetEnabled(self.loadMapLoadButton, true)
		guiSetEnabled(self.loadMapDeleteButton, true)
	end
	
	if (guiGridListGetRowCount(self.loadMapGridList) ~= #self.mapList) then
		self:refreshMapGridList()
	end
	
	self.camX, self.camY, self.camZ = getCameraMatrix()
	
	guiSetText(self.posXLabel, "x: " .. string.format("%.4f", self.camX))
	guiSetText(self.posYLabel, "y: " .. string.format("%.4f", self.camY))
	guiSetText(self.posZLabel, "z: " .. string.format("%.4f", self.camZ))
	guiSetText(self.editorModeLabel, "Editor Mode: " .. self.parent.editorState)
	
	guiSetText(self.allParticlesLabel, "Possible Particles (all): " .. tostring(self.player:getData("allParticles")))
	guiSetText(self.streamedInParticlesLabel, "Possible Particles (streamed in): " .. tostring(self.player:getData("streamedInParticles")))
	guiSetText(self.streamedInActiveParticlesLabel, "Current Particles: " .. tostring(self.player:getData("streamedInActiveParticles")))
	guiSetText(self.fpsLabel, "FPS: " .. tostring(getClientFPS()))
end


function EditorGUIClassC:onClientGUIFocus()
	if (source == self.previousEffectButton) then
		self.selectedGUIElement = self.previousEffectButton
	elseif (source == self.nextEffectButton) then 
		self.selectedGUIElement = self.nextEffectButton
	elseif (source == self.textureComboBox) then 
		self.selectedGUIElement = self.textureComboBox
	elseif (source == self.coordsXEdit) then 
		self.selectedGUIElement = self.coordsXEdit
	elseif (source == self.coordsYEdit) then 
		self.selectedGUIElement = self.coordsYEdit
	elseif (source == self.coordsZEdit) then 
		self.selectedGUIElement = self.coordsZEdit
	elseif (source == self.maxParticlesScrollBar) then
		self.selectedGUIElement = self.maxParticlesScrollBar
	elseif (source == self.radiusScrollBar) then
		self.selectedGUIElement = self.radiusScrollBar
	elseif (source == self.turbulenceScrollBar) then
		self.selectedGUIElement = self.turbulenceScrollBar
	elseif (source == self.velocityXScrollBar) then
		self.selectedGUIElement = self.velocityXScrollBar
	elseif (source == self.velocityYScrollBar) then
		self.selectedGUIElement = self.velocityYScrollBar
	elseif (source == self.velocityZScrollBar) then
		self.selectedGUIElement = self.velocityZScrollBar
	elseif (source == self.effectRotationScrollBar) then
		self.selectedGUIElement = self.effectRotationScrollBar
	elseif (source == self.startParticleSizeScrollBar) then
		self.selectedGUIElement = self.startParticleSizeScrollBar
	elseif (source == self.endParticleSizeScrollBar) then
		self.selectedGUIElement = self.endParticleSizeScrollBar
	elseif (source == self.particleLifeTimeScrollBar) then
		self.selectedGUIElement = self.particleLifeTimeScrollBar
	elseif (source == self.brightnessScrollBar) then
		self.selectedGUIElement = self.brightnessScrollBar
	elseif (source == self.alphaScrollBar) then
		self.selectedGUIElement = self.alphaScrollBar
	elseif (source == self.isRainBowColorsCheckBox) then
		self.selectedGUIElement = self.isRainBowColorsCheckBox
	elseif (source == self.changeColorButton) then
		self.selectedGUIElement = self.changeColorButton
	elseif (source == self.loadPresetButton) then
		self.selectedGUIElement = self.loadPresetButton
	elseif (source == self.loadPresetLoadButton) then
		self.selectedGUIElement = self.loadPresetLoadButton
	elseif (source == self.loadPresetDeleteButton) then
		self.selectedGUIElement = self.loadPresetDeleteButton
	elseif (source == self.reallyDeletePresetOKButton) then
		self.selectedGUIElement = self.reallyDeletePresetOKButton
	elseif (source == self.reallyDeletePresetCancelButton) then
		self.selectedGUIElement = self.reallyDeletePresetCancelButton
	elseif (source == self.loadPresetCancelButton) then
		self.selectedGUIElement = self.loadPresetCancelButton	
	elseif (source == self.savePresetEdit) then
		self.selectedGUIElement = self.savePresetEdit
	elseif (source == self.savePresetButton) then
		self.selectedGUIElement = self.savePresetButton
	elseif (source == self.presetExistOKButton) then
		self.selectedGUIElement = self.presetExistOKButton
	elseif (source == self.presetExistCancelButton) then
		self.selectedGUIElement = self.presetExistCancelButton
	elseif (source == self.newMapButton) then
		self.selectedGUIElement = self.newMapButton
	elseif (source == self.newMapOKButton) then
		self.selectedGUIElement = self.newMapOKButton
	elseif (source == self.newMapCancelButton) then
		self.selectedGUIElement = self.newMapCancelButton
	elseif (source == self.loadMapButton) then
		self.selectedGUIElement = self.loadMapButton
	elseif (source == self.loadMapLoadButton) then
		self.selectedGUIElement = self.loadMapLoadButton
	elseif (source == self.loadMapDeleteButton) then
		self.selectedGUIElement = self.loadMapDeleteButton
	elseif (source == self.reallyDeleteMapOKButton) then
		self.selectedGUIElement = self.reallyDeleteMapOKButton
	elseif (source == self.reallyDeleteMapCancelButton) then
		self.selectedGUIElement = self.reallyDeleteMapCancelButton
	elseif (source == self.loadMapCancelButton) then
		self.selectedGUIElement = self.loadMapCancelButton
	elseif (source == self.saveMapButton) then
		self.selectedGUIElement = self.saveMapButton
	elseif (source == self.saveMapEdit) then
		self.selectedGUIElement = self.saveMapEdit		
	elseif (source == self.saveMapFinalButton) then
		self.selectedGUIElement = self.saveMapFinalButton
	elseif (source == self.saveMapCancelButton) then
		self.selectedGUIElement = self.saveMapCancelButton
	elseif (source == self.mapExistOKButton) then
		self.selectedGUIElement = self.mapExistOKButton
	elseif (source == self.mapExistCancelButton) then
		self.selectedGUIElement = self.mapExistCancelButton
	end
end


function EditorGUIClassC:onParticleEffectSelected(selectedEffect)
	self.selectedEffect = selectedEffect
	self.selectedGUIElement = nil
	
	if (self.selectedEffect) and (isElement(self.selectedEffect)) then	
		if (self.selectedEffect.id) then
			guiSetText(self.selectedEffectLabel, "'" .. tostring(selectedEffect.id) .. "'")
			
			self.texture = selectedEffect:getData("texture")
			
			for i = 0, 25, 1 do
				local texture = guiComboBoxGetItemText(self.textureComboBox, i)
				if (texture == self.texture) then
					guiComboBoxSetSelected(self.textureComboBox, i)
					
					break
				end
			end
			
			self.x = selectedEffect:getData("x")
			self.y = selectedEffect:getData("y")
			self.z = selectedEffect:getData("z")
			
			guiSetText(self.coordsXEdit, self.x)
			guiSetText(self.coordsYEdit, self.y)
			guiSetText(self.coordsZEdit, self.z)
			
			self.maxParticles = selectedEffect:getData("maxParticles")
			
			self.maxParticlesValue = (100/self.maxParticlesCount) * self.maxParticles
			guiScrollBarSetScrollPosition(self.maxParticlesScrollBar, self.maxParticlesValue)
			guiSetText(self.maxParticleLabel, "Max Particles: " .. self.maxParticles)
			
			self.radius = selectedEffect:getData("radius")
			
			self.radiusValue = (100/self.maxRadiusValue) * self.radius
			guiScrollBarSetScrollPosition(self.radiusScrollBar, self.radiusValue)
			guiSetText(self.radiusLabel, "Radius: " .. self.radius)
			
			self.turbulence = selectedEffect:getData("turbulence")
			
			self.turbulenceValue = (100/self.maxTurbulenceValue) * self.turbulence
			guiScrollBarSetScrollPosition(self.turbulenceScrollBar, self.turbulenceValue)
			guiSetText(self.turbulenceLabel, "Turbulence: " .. self.turbulence)
			
			self.velocityX = selectedEffect:getData("velocityX")
			
			self.velocityXValue = (100/self.maxVelocityXValue) * self.velocityX
			guiScrollBarSetScrollPosition(self.velocityXScrollBar, self.velocityXValue)
			guiSetText(self.velocityXLabel, "Velocity X: " .. self.velocityX)
	
			self.velocityY = selectedEffect:getData("velocityY")

			self.velocityYValue = (100/self.maxVelocityYValue) * self.velocityY
			guiScrollBarSetScrollPosition(self.velocityYScrollBar, self.velocityYValue)
			guiSetText(self.velocityYLabel, "Velocity Y: " .. self.velocityY)

			self.velocityZ = selectedEffect:getData("velocityZ")
			
			self.velocityZValue = (100/self.maxVelocityZValue) * self.velocityZ
			guiScrollBarSetScrollPosition(self.velocityZScrollBar, self.velocityZValue)
			guiSetText(self.velocityZLabel, "Velocity Z: " .. self.velocityZ)
			
			self.effectRotation = selectedEffect:getData("effectRotation")
			
			self.effectRotationValue = (100/self.maxRotationValue) * self.effectRotation
			guiScrollBarSetScrollPosition(self.effectRotationScrollBar, self.effectRotationValue)
			guiSetText(self.effectRotationLabel, "Effect Rotation: " .. self.effectRotation)
			
			self.startParticleSize = selectedEffect:getData("startParticleSize")
			
			self.startParticleSizeValue = (100/self.maxStartSizeValue) * self.startParticleSize
			guiScrollBarSetScrollPosition(self.startParticleSizeScrollBar, self.startParticleSizeValue)
			guiSetText(self.startParticleSizeLabel, "Particle Start Size: " .. self.startParticleSize)
			
			self.endParticleSize = selectedEffect:getData("endParticleSize")
			
			self.endParticleSizeValue = (100/self.maxEndSizeValue) * self.endParticleSize
			guiScrollBarSetScrollPosition(self.endParticleSizeScrollBar, self.endParticleSizeValue)
			guiSetText(self.endParticleSizeLabel, "Particle End Size: " .. self.endParticleSize)
			
			self.particleLifeTime = selectedEffect:getData("particleLifeTime")
			
			self.particleLifeTimeValue = (100/self.maxLifeTimeValue) * self.particleLifeTime
			guiScrollBarSetScrollPosition(self.particleLifeTimeScrollBar, self.particleLifeTimeValue)
			guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: " .. self.particleLifeTime .. " (ms)")
			
			self.alpha = selectedEffect:getData("effectColorAlpha")
			
			self.alphaValue = (100/self.maxAlphaValue) * self.alpha
			guiScrollBarSetScrollPosition(self.alphaScrollBar, self.alphaValue)
			guiSetText(self.alphaLabel, "Alpha: " .. self.alpha)
			
			self.brightness = selectedEffect:getData("effectBrightness")
			
			self.brightnessValue = (100/self.maxBrightnessValue) * self.brightness
			guiScrollBarSetScrollPosition(self.brightnessScrollBar, self.brightnessValue)
			guiSetText(self.brightnessLabel, "Brightness: " .. self.brightness)
			
			self.isRainBowColors = selectedEffect:getData("isRainBowColor")
			
			if (self.isRainBowColors == "true") then
				guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, true)
			else
				guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, false)
			end
		end
	end
end


function EditorGUIClassC:onPresetWasLoaded(presetTable)
	if (presetTable) then
		local presetTable = presetTable
		
		self.texture = presetTable.texture
			
		for i = 0, 25, 1 do
			local texture = guiComboBoxGetItemText(self.textureComboBox, i)
			if (texture == self.texture) then
				guiComboBoxSetSelected(self.textureComboBox, i)
				
				break
			end
		end
		
		if (self.selectedEffect) then
			triggerEvent("onTextureChanged", root, self.selectedEffect.id, self.texture)
		end
		
		self.maxParticles = presetTable.maxParticles
			
		self.maxParticlesValue = (100/self.maxParticlesCount) * self.maxParticles
		guiScrollBarSetScrollPosition(self.maxParticlesScrollBar, self.maxParticlesValue)
		guiSetText(self.maxParticleLabel, "Max Particles: " .. self.maxParticles)
		
		if (self.selectedEffect) then
			triggerEvent("onMaxParticlesChanged", root, self.selectedEffect.id, self.maxParticles)
		end
		
		self.radius = presetTable.radius
			
		self.radiusValue = (100/self.maxRadiusValue) * self.radius
		guiScrollBarSetScrollPosition(self.radiusScrollBar, self.radiusValue)
		guiSetText(self.radiusLabel, "Radius: " .. self.radius)
		
		if (self.selectedEffect) then
			triggerEvent("onRadiusChanged", root, self.selectedEffect.id, self.radius)
		end
		
		self.turbulence = presetTable.turbulence
		
		self.turbulenceValue = (100/self.maxTurbulenceValue) * self.turbulence
		guiScrollBarSetScrollPosition(self.turbulenceScrollBar, self.turbulenceValue)
		guiSetText(self.turbulenceLabel, "Turbulence: " .. self.turbulence)
		
		if (self.selectedEffect) then
			triggerEvent("onTurbulenceChanged", root, self.selectedEffect.id, self.turbulence)
		end
		
		self.velocityX = presetTable.velocityX
		
		self.velocityXValue = (100/self.maxVelocityXValue) * self.velocityX
		guiScrollBarSetScrollPosition(self.velocityXScrollBar, self.velocityXValue)
		guiSetText(self.velocityXLabel, "Velocity X: " .. self.velocityX)
		
		if (self.selectedEffect) then
			triggerEvent("onVelocityXChanged", root, self.selectedEffect.id, self.velocityX)
		end

		self.velocityY = presetTable.velocityY

		self.velocityYValue = (100/self.maxVelocityYValue) * self.velocityY
		guiScrollBarSetScrollPosition(self.velocityYScrollBar, self.velocityYValue)
		guiSetText(self.velocityYLabel, "Velocity Y: " .. self.velocityY)
		
		if (self.selectedEffect) then
			triggerEvent("onVelocityYChanged", root, self.selectedEffect.id, self.velocityY)
		end

		self.velocityZ = presetTable.velocityZ
		
		self.velocityZValue = (100/self.maxVelocityZValue) * self.velocityZ
		guiScrollBarSetScrollPosition(self.velocityZScrollBar, self.velocityZValue)
		guiSetText(self.velocityZLabel, "Velocity Z: " .. self.velocityZ)
		
		if (self.selectedEffect) then
			triggerEvent("onVelocityZChanged", root, self.selectedEffect.id, self.velocityZ)
		end
		
		self.effectRotation = presetTable.effectRotation
		
		self.effectRotationValue = (100/self.maxRotationValue) * self.effectRotation
		guiScrollBarSetScrollPosition(self.effectRotationScrollBar, self.effectRotationValue)
		guiSetText(self.effectRotationLabel, "Effect Rotation: " .. self.effectRotation)
		
		if (self.selectedEffect) then
			triggerEvent("onEffectRotationChanged", root, self.selectedEffect.id, self.effectRotation)
		end
		
		self.startParticleSize = presetTable.startParticleSize
		
		self.startParticleSizeValue = (100/self.maxStartSizeValue) * self.startParticleSize
		guiScrollBarSetScrollPosition(self.startParticleSizeScrollBar, self.startParticleSizeValue)
		guiSetText(self.startParticleSizeLabel, "Particle Start Size: " .. self.startParticleSize)
		
		if (self.selectedEffect) then
			triggerEvent("onStartParticleSizeChanged", root, self.selectedEffect.id, self.startParticleSize)
		end
		
		self.endParticleSize = presetTable.endParticleSize
		
		self.endParticleSizeValue = (100/self.maxEndSizeValue) * self.endParticleSize
		guiScrollBarSetScrollPosition(self.endParticleSizeScrollBar, self.endParticleSizeValue)
		guiSetText(self.endParticleSizeLabel, "Particle End Size: " .. self.endParticleSize)
		
		if (self.selectedEffect) then
			triggerEvent("onEndParticleSizeChanged", root, self.selectedEffect.id, self.endParticleSize)
		end
		
		self.particleLifeTime = presetTable.particleLifeTime
		
		self.particleLifeTimeValue = (100/self.maxLifeTimeValue) * self.particleLifeTime
		guiScrollBarSetScrollPosition(self.particleLifeTimeScrollBar, self.particleLifeTimeValue)
		guiSetText(self.particleLifeTimeLabel, "Particle Lifetime: " .. self.particleLifeTime .. " (ms)")
		
		if (self.selectedEffect) then
			triggerEvent("onLifeTimeChanged", root, self.selectedEffect.id, self.particleLifeTime)
		end
		
		self.alpha = presetTable.effectColorAlpha
		
		self.alphaValue = (100/self.maxAlphaValue) * self.alpha
		guiScrollBarSetScrollPosition(self.alphaScrollBar, self.alphaValue)
		guiSetText(self.alphaLabel, "Alpha: " .. self.alpha)
		
		if (self.selectedEffect) then
			triggerEvent("onAlphaChanged", root, self.selectedEffect.id, self.alpha)
		end
		
		self.brightness = presetTable.effectBrightness
		
		self.brightnessValue = (100/self.maxBrightnessValue) * self.brightness
		guiScrollBarSetScrollPosition(self.brightnessScrollBar, self.brightnessValue)
		guiSetText(self.brightnessLabel, "Brightness: " .. self.brightness)
		
		if (self.selectedEffect) then
			triggerEvent("onBrightnessChanged", root, self.selectedEffect.id, self.brightness)
		end
		
		self.isRainBowColors = presetTable.isRainBowColor
		
		if (self.isRainBowColors == "true") then
			guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, true)
		else
			guiCheckBoxSetSelected(self.isRainBowColorsCheckBox, false)
		end
		
		if (self.selectedEffect) then
			triggerEvent("onRainbowColorChanged", root, self.selectedEffect.id, self.isRainBowColors)
		end
	end
end


function EditorGUIClassC:onParticleEffectDeSelected()
	self.selectedEffect = nil
	guiSetText(self.selectedEffectLabel, "'Nothing'")
end


function EditorGUIClassC:destructor()
	removeEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	removeEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	removeEventHandler("onClientGUIClick", root, self.m_OnClientGUIClick)
	removeEventHandler("onClientGUIFocus", root, self.m_OnClientGUIFocus)
	removeEventHandler("onPresetAlreadyExist", root, self.m_OnPresetAlreadyExist)
	removeEventHandler("presetListRefreshed", root, self.m_PresetListRefreshed)
	removeEventHandler("onPresetWasLoaded", root, self.m_OnPresetWasLoaded)
	removeEventHandler("onMapAlreadyExist", root, self.m_OnMapAlreadyExist)
	removeEventHandler("onMapListRefreshed", root, self.m_OnMapListRefreshed)
	removeEventHandler("refreshMapGridList", root, self.m_RefreshMapGridList)
	
	unbindKey("F3", "down", self.m_ToggleEditorGUI)
	
	guiSetVisible(self.editorMainWindow, false)
	guiSetVisible(self.newMapWindow, false)
	guiSetVisible(self.loadMapWindow, false)
	guiSetVisible(self.saveMapWindow, false)
	guiSetVisible(self.mapExistWindow, false)
	guiSetVisible(self.reallyDeleteMapWindow, false)
	guiSetVisible(self.particelSettingsWindow, false)
	guiSetVisible(self.loadPresetWindow, false)
	guiSetVisible(self.savePresetWindow, false)
	guiSetVisible(self.presetExistWindow, false)
	guiSetVisible(self.reallyDeletePresetWindow, false)
	guiSetVisible(self.changeColorWindow, false)
	
	self.presetList = nil
	
	mainOutput("EditorGUIClassC was stopped...")
end