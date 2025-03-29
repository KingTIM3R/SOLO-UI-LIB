--[[
    Frame Component
    A customizable frame with Solo Leveling aesthetics
]]

local TweenService = game:GetService("TweenService")

local Frame = {}
Frame.__index = Frame

function Frame.new(options)
    local self = setmetatable({}, Frame)
    
    -- Default options
    options = options or {}
    self.Name = options.Name or "Frame"
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Size = options.Size or UDim2.new(0, 200, 0, 200)
    self.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.BackgroundTransparency = options.BackgroundTransparency or 0
    
    -- Create the frame
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name
    self.Instance.Position = self.Position
    self.Instance.Size = self.Size
    self.Instance.AnchorPoint = self.AnchorPoint
    self.Instance.BackgroundColor3 = self.Theme.FrameBackground
    self.Instance.BackgroundTransparency = self.BackgroundTransparency
    self.Instance.BorderSizePixel = 0
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 6)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.FrameStroke
    self.Stroke.Thickness = 1
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.FrameGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.FrameGradientEnd)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    return self
end

function Frame:AddChild(child)
    if typeof(child) == "table" and child.Instance then
        child.Instance.Parent = self.Instance
    elseif typeof(child) == "Instance" then
        child.Parent = self.Instance
    end
    return child
end

function Frame:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.FrameBackground
    self.Stroke.Color = theme.FrameStroke
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.FrameGradientStart),
        ColorSequenceKeypoint.new(1, theme.FrameGradientEnd)
    })
end

function Frame:SetVisible(visible)
    self.Instance.Visible = visible
end

function Frame:ApplyBlur(strength)
    strength = strength or 10
    
    local blur = Instance.new("BlurEffect")
    blur.Name = "FrameBlur"
    blur.Size = strength
    blur.Parent = self.Instance
end

function Frame:Destroy()
    self.Instance:Destroy()
    setmetatable(self, nil)
end

return Frame
