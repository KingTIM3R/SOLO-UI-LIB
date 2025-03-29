--[[
    SoloLevelingUI
    A UI library for Roblox inspired by Solo Leveling's visual style
    
    Features:
    - Notification system
    - Customizable UI elements
    - Responsive design
    - Solo Leveling aesthetics
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Components
local Button = require(script.Components.Button)
local Frame = require(script.Components.Frame)
local TextInput = require(script.Components.TextInput)
local Notification = require(script.Components.Notification)
local Window = require(script.Components.Window)
local Themes = require(script.Themes)
local Utility = require(script.Utility)

local SoloLevelingUI = {}
SoloLevelingUI.__index = SoloLevelingUI

-- Library Constants
SoloLevelingUI.Version = "1.0.0"

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
        self.ScreenGui.Parent = self.Parent
    else
        self.ScreenGui.Parent = PlayerGui
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

-- Destroy the UI
function SoloLevelingUI:Destroy()
    self.ScreenGui:Destroy()
    self.Windows = {}
    setmetatable(self, nil)
end

return SoloLevelingUI
