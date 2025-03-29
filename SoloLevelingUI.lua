--[[
    SoloLevelingUI
    A UI library for Roblox inspired by Solo Leveling's visual style
    
    Features:
    - Notification system
    - Customizable UI elements
    - Responsive design
    - Solo Leveling aesthetics
]]

-- Safe service access
local function getSafe(callback)
    local success, result = pcall(callback)
    return success and result or nil
end

local RunService = getSafe(function() return game:GetService("RunService") end)
local TweenService = getSafe(function() return game:GetService("TweenService") end)
local UserInputService = getSafe(function() return game:GetService("UserInputService") end)
local Players = getSafe(function() return game:GetService("Players") end)
local HttpService = getSafe(function() return game:GetService("HttpService") end)

-- Safe player reference
local LocalPlayer, PlayerGui
if Players then
    LocalPlayer = getSafe(function() return Players.LocalPlayer end)
    if LocalPlayer then
        PlayerGui = getSafe(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    end
end

-- Safe component loading
local function loadComponent(name)
    -- First try to load from local files if running as a module
    if script and script:FindFirstChild("Components") and script.Components:FindFirstChild(name) then
        local success, component = pcall(function() 
            return require(script.Components[name]) 
        end)
        if success then return component end
    end
    
    -- Next try using parent directory components
    if script and script.Parent and script.Parent:FindFirstChild("Components") and script.Parent.Components:FindFirstChild(name) then
        local success, component = pcall(function() 
            return require(script.Parent.Components[name]) 
        end)
        if success then return component end
    end
    
    -- Fallback to HTTP loading (only works in proper environments with HTTP enabled)
    if HttpService then
        local success, component = pcall(function()
            return loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/SOLO-UI-LIB/refs/heads/main/' .. name .. '.lua'))()
        end)
        if success then return component end
    end
    
    -- If all else fails, return a component stub
    warn("SoloLevelingUI: Failed to load component: " .. name)
    
    -- Create a basic stub component with minimum functionality to prevent errors
    local stub = {}
    stub.__index = stub
    
    stub.new = function()
        local self = setmetatable({}, stub)
        self.Instance = Instance.new("Frame")
        self.Instance.BackgroundTransparency = 1
        self.Instance.Size = UDim2.new(0, 200, 0, 50)
        self.Instance.Name = name .. "_Stub"
        return self
    end
    
    stub.SetTheme = function() end
    stub.Destroy = function(self)
        if self.Instance then
            self.Instance:Destroy()
        end
    end
    
    if name == "Window" then
        stub.CreateButton = function() return {} end
        stub.CreateFrame = function() return {} end
        stub.CreateTextInput = function() return {} end
        stub.Close = function() end
    end
    
    return stub
end

-- Components
local Button = loadComponent("Button")
local Frame = loadComponent("Frame")
local TextInput = loadComponent("TextInput")
local Notification = loadComponent("Notification") 
local Window = loadComponent("Window")

-- Try to load themes and utility
local Themes = {}
local Utility = {}

if script and script:FindFirstChild("Themes") then
    local success, result = pcall(function() return require(script.Themes) end)
    if success then Themes = result end
elseif HttpService then
    local success, result = pcall(function() 
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/SOLO-UI-LIB/refs/heads/main/Themes.lua'))() 
    end)
    if success then Themes = result end
end

if script and script:FindFirstChild("Utility") then
    local success, result = pcall(function() return require(script.Utility) end)
    if success then Utility = result end
elseif HttpService then
    local success, result = pcall(function() 
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/SOLO-UI-LIB/refs/heads/main/Utility.lua'))() 
    end)
    if success then Utility = result end
end

-- Set default theme if none loaded
if not Themes.Default then
    Themes.Default = {
        Font = Enum.Font.GothamBold,
        AccentColor = Color3.fromRGB(64, 157, 254),  -- Blue accent (Solo Leveling)
        WindowBackground = Color3.fromRGB(25, 30, 40),
        TitleText = Color3.fromRGB(255, 255, 255),
        NotificationText = Color3.fromRGB(200, 200, 220),
        ButtonBackground = Color3.fromRGB(30, 35, 50),
        ButtonText = Color3.fromRGB(255, 255, 255)
    }
end

local SoloLevelingUI = {}
SoloLevelingUI.__index = SoloLevelingUI

-- Library Constants
SoloLevelingUI.Version = "1.0.0"
SoloLevelingUI.Themes = Themes -- Expose themes directly on the library

-- Initialize the UI Framework
function SoloLevelingUI.new(options)
    local self = setmetatable({}, SoloLevelingUI)
    
    -- Default options
    options = options or {}
    self.Name = options.Name or "SoloLevelingUI"
    self.Theme = options.Theme or Themes.Default
    self.Parent = options.Parent
    self.ZIndexBehavior = options.ZIndexBehavior or Enum.ZIndexBehavior.Sibling
    
    -- Create the ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = self.ZIndexBehavior
    
    -- Create container for notifications
    self.NotificationContainer = Instance.new("Frame")
    self.NotificationContainer.Name = "NotificationContainer"
    self.NotificationContainer.BackgroundTransparency = 1
    self.NotificationContainer.Position = UDim2.new(0.5, 0, 0, 20)
    self.NotificationContainer.Size = UDim2.new(0, 500, 0, 0)
    self.NotificationContainer.AnchorPoint = Vector2.new(0.5, 0)
    self.NotificationContainer.AutomaticSize = Enum.AutomaticSize.Y
    self.NotificationContainer.Parent = self.ScreenGui
    
    -- Layout for notifications
    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.Padding = UDim.new(0, 10)
    notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.Parent = self.NotificationContainer
    
    -- Windows collection
    self.Windows = {}
    
    -- Assign parent
    if self.Parent then
        pcall(function() self.ScreenGui.Parent = self.Parent end)
    elseif PlayerGui then
        pcall(function() self.ScreenGui.Parent = PlayerGui end)
    else
        -- Fallback for testing environments
        pcall(function()
            if game:FindFirstChild("CoreGui") then
                self.ScreenGui.Parent = game.CoreGui
            elseif game:FindFirstChild("Players") and game.Players.LocalPlayer then
                self.ScreenGui.Parent = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            end
        end)
        warn("SoloLevelingUI: Could not find a suitable parent for ScreenGui. UI may not be visible.")
    end
    
    return self
end

-- Create a new window
function SoloLevelingUI:CreateWindow(options)
    options = options or {}
    options.Parent = self.ScreenGui
    options.Theme = options.Theme or self.Theme
    
    local newWindow = Window.new(options)
    table.insert(self.Windows, newWindow)
    
    return newWindow
end

-- Create a notification
function SoloLevelingUI:Notify(options)
    options = options or {}
    options.Parent = self.NotificationContainer
    options.Theme = options.Theme or self.Theme
    
    return Notification.new(options)
end

-- Set a theme for the entire UI
function SoloLevelingUI:SetTheme(theme)
    self.Theme = theme
    
    -- Update theme for all windows
    for _, window in ipairs(self.Windows) do
        window:SetTheme(theme)
    end
end

-- Create shadow monarch particles effect (special Solo Leveling effect)
function SoloLevelingUI:CreateShadowMonarchEffect(parent, intensity)
    intensity = intensity or 1
    parent = parent or self.ScreenGui
    
    -- If Utility module failed to load, provide minimal implementation
    if not Utility.CreateBlueParticles then
        pcall(function()
            -- Basic effect if utility module failed to load
            local particles = {}
            local count = math.floor(30 * intensity)
            
            for i = 1, count do
                local particle = Instance.new("Frame")
                particle.Name = "ShadowParticle_" .. i
                particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
                particle.BorderSizePixel = 0
                
                -- Shadow Monarch particles are primarily purple with some blue
                local isMonarch = math.random() < 0.7 -- 70% chance of purple
                if isMonarch then
                    particle.BackgroundColor3 = Color3.fromRGB(150, 0, 255) -- Purple for Shadow Monarch
                else
                    particle.BackgroundColor3 = Color3.fromRGB(64, 157, 254) -- Blue for normal
                end
                
                particle.BackgroundTransparency = 0.2
                particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
                
                -- Add corner radius
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0) -- Make it circular
                corner.Parent = particle
                
                particle.Parent = parent
                table.insert(particles, particle)
                
                -- Animate out and destroy after random time
                spawn(function()
                    local time = math.random(20, 40) / 10
                    local tStart = tick()
                    
                    -- Simple animation loop
                    while tick() - tStart < time and particle.Parent do
                        particle.Position = UDim2.new(
                            particle.Position.X.Scale, 
                            particle.Position.X.Offset,
                            particle.Position.Y.Scale - 0.01, 
                            particle.Position.Y.Offset
                        )
                        particle.BackgroundTransparency = 0.2 + ((tick() - tStart) / time * 0.8)
                        wait(0.05)
                    end
                    
                    if particle.Parent then
                        particle:Destroy()
                    end
                end)
            end
            
            return particles
        end)
        return
    end
    
    -- If Utility module loaded properly, use that with Shadow Monarch mode (true)
    if Utility.CreateBlueParticles then
        return Utility.CreateBlueParticles(parent, 30 * intensity, 3, true) -- Last parameter true for Shadow Monarch mode
    end
end

-- Destroy the UI
function SoloLevelingUI:Destroy()
    self.ScreenGui:Destroy()
    self.Windows = {}
    setmetatable(self, nil)
end

return SoloLevelingUI
