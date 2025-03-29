--[[
    Button Component
    A customizable button in the Solo Leveling style
]]

local TweenService = game:GetService("TweenService")
local Utility = require(script.Parent.Parent.Utility)

local Button = {}
Button.__index = Button

function Button.new(options)
    local self = setmetatable({}, Button)
    
    -- Default options
    options = options or {}
    self.Name = options.Name or "Button"
    self.Text = options.Text or "Button"
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Size = options.Size or UDim2.new(0, 200, 0, 40)
    self.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Callback = options.Callback or function() end
    
    -- Create the button
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = self.Name
    self.Instance.Text = ""
    self.Instance.Position = self.Position
    self.Instance.Size = self.Size
    self.Instance.AnchorPoint = self.AnchorPoint
    self.Instance.BackgroundColor3 = self.Theme.ButtonBackground
    self.Instance.BorderSizePixel = 0
    self.Instance.AutoButtonColor = false
    self.Instance.ZIndex = 2
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 4)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.ButtonStroke
    self.Stroke.Thickness = 1
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.ButtonGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.ButtonGradientEnd)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Text label
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "TextLabel"
    self.TextLabel.Text = self.Text
    self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Font = self.Theme.Font
    self.TextLabel.TextColor3 = self.Theme.ButtonText
    self.TextLabel.TextSize = self.Theme.ButtonTextSize
    self.TextLabel.ZIndex = 3
    self.TextLabel.Parent = self.Instance
    
    -- Glow effect
    self.Glow = Instance.new("ImageLabel")
    self.Glow.Name = "Glow"
    self.Glow.BackgroundTransparency = 1
    self.Glow.Size = UDim2.new(1, 20, 1, 20)
    self.Glow.Position = UDim2.new(0, -10, 0, -10)
    self.Glow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Glow.ImageColor3 = self.Theme.AccentColor
    self.Glow.ImageTransparency = 0.8
    self.Glow.ZIndex = 1
    self.Glow.Parent = self.Instance
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    return self
end

function Button:_connectEvents()
    -- Hover effect
    self.Instance.MouseEnter:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ButtonBackgroundHover
        }):Play()
        
        TweenService:Create(self.Glow, TweenInfo.new(0.3), {
            ImageTransparency = 0.6
        }):Play()
        
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), {
            Color = self.Theme.AccentColor,
            Thickness = 2
        }):Play()
    end)
    
    self.Instance.MouseLeave:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.ButtonBackground
        }):Play()
        
        TweenService:Create(self.Glow, TweenInfo.new(0.3), {
            ImageTransparency = 0.8
        }):Play()
        
        TweenService:Create(self.Stroke, TweenInfo.new(0.2), {
            Color = self.Theme.ButtonStroke,
            Thickness = 1
        }):Play()
    end)
    
    -- Click effect
    self.Instance.MouseButton1Down:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.1), {
            Size = UDim2.new(self.Size.X.Scale * 0.95, self.Size.X.Offset * 0.95, 
                              self.Size.Y.Scale * 0.95, self.Size.Y.Offset * 0.95)
        }):Play()
    end)
    
    self.Instance.MouseButton1Up:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.1), {
            Size = self.Size
        }):Play()
    end)
    
    -- Callback
    self.Instance.MouseButton1Click:Connect(function()
        -- Play click effect
        Utility.PlaySoloLevelingEffect(self.Instance)
        
        -- Execute callback
        self.Callback()
    end)
end

function Button:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.ButtonBackground
    self.TextLabel.Font = theme.Font
    self.TextLabel.TextColor3 = theme.ButtonText
    self.TextLabel.TextSize = theme.ButtonTextSize
    self.Glow.ImageColor3 = theme.AccentColor
    self.Stroke.Color = theme.ButtonStroke
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.ButtonGradientStart),
        ColorSequenceKeypoint.new(1, theme.ButtonGradientEnd)
    })
end

function Button:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Button:SetCallback(callback)
    self.Callback = callback
end

function Button:SetVisible(visible)
    self.Instance.Visible = visible
end

function Button:Destroy()
    self.Instance:Destroy()
    setmetatable(self, nil)
end

return Button
