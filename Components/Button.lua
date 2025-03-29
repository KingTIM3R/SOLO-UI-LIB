--[[
    Button Component
    Solo Leveling style button with hover effects
]]

local TweenService = game:GetService("RunService") and game:GetService("TweenService")
local UserInputService = game:GetService("RunService") and game:GetService("UserInputService")

local Button = {}
Button.__index = Button

function Button.new(options)
    local self = setmetatable({}, Button)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Button"
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Size = options.Size or UDim2.new(0, 200, 0, 40)
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Callback = options.Callback or function() end
    self.Disabled = options.Disabled or false
    self.ZIndex = options.ZIndex or 1
    
    -- Create the button
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = "Button_" .. self.Text:gsub(" ", "_")
    self.Instance.Size = self.Size
    self.Instance.Position = self.Position
    self.Instance.BackgroundColor3 = self.Theme.ButtonBackground
    self.Instance.BackgroundTransparency = 0
    self.Instance.BorderSizePixel = 0
    self.Instance.Font = self.Theme.Font
    self.Instance.TextColor3 = self.Theme.ButtonText
    self.Instance.TextSize = self.Theme.ButtonTextSize or 16
    self.Instance.Text = self.Text
    self.Instance.AutoButtonColor = false
    self.Instance.ZIndex = self.ZIndex
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 4)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.ButtonStroke or self.Theme.AccentColor
    self.Stroke.Thickness = 1
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.ButtonGradientStart or self.Theme.ButtonBackground),
        ColorSequenceKeypoint.new(1, self.Theme.ButtonGradientEnd or self.Theme.ButtonBackground)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Add glow effect
    self.Glow = Instance.new("ImageLabel")
    self.Glow.Name = "Glow"
    self.Glow.BackgroundTransparency = 1
    self.Glow.Size = UDim2.new(1, 20, 1, 20)
    self.Glow.Position = UDim2.new(0, -10, 0, -10)
    self.Glow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Glow.ImageColor3 = self.Theme.AccentColor
    self.Glow.ImageTransparency = 0.9
    self.Glow.ZIndex = self.Instance.ZIndex - 1
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
    -- Mouse enter (hover)
    self.Instance.MouseEnter:Connect(function()
        if self.Disabled then return end
        
        if TweenService then
            TweenService:Create(self.Instance, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.ButtonBackgroundHover
            }):Play()
            
            TweenService:Create(self.Glow, TweenInfo.new(0.3), {
                ImageTransparency = 0.7
            }):Play()
        else
            self.Instance.BackgroundColor3 = self.Theme.ButtonBackgroundHover
            self.Glow.ImageTransparency = 0.7
        end
    end)
    
    -- Mouse leave
    self.Instance.MouseLeave:Connect(function()
        if self.Disabled then return end
        
        if TweenService then
            TweenService:Create(self.Instance, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.ButtonBackground
            }):Play()
            
            TweenService:Create(self.Glow, TweenInfo.new(0.3), {
                ImageTransparency = 0.9
            }):Play()
        else
            self.Instance.BackgroundColor3 = self.Theme.ButtonBackground
            self.Glow.ImageTransparency = 0.9
        end
    end)
    
    -- Mouse button down
    self.Instance.MouseButton1Down:Connect(function()
        if self.Disabled then return end
        
        if TweenService then
            TweenService:Create(self.Instance, TweenInfo.new(0.1), {
                Size = UDim2.new(
                    self.Size.X.Scale,
                    self.Size.X.Offset * 0.95,
                    self.Size.Y.Scale,
                    self.Size.Y.Offset * 0.95
                ),
                Position = UDim2.new(
                    self.Position.X.Scale,
                    self.Position.X.Offset + self.Size.X.Offset * 0.025,
                    self.Position.Y.Scale,
                    self.Position.Y.Offset + self.Size.Y.Offset * 0.025
                )
            }):Play()
        else
            self.Instance.Size = UDim2.new(
                self.Size.X.Scale,
                self.Size.X.Offset * 0.95,
                self.Size.Y.Scale,
                self.Size.Y.Offset * 0.95
            )
        end
    end)
    
    -- Mouse button up
    self.Instance.MouseButton1Up:Connect(function()
        if self.Disabled then return end
        
        if TweenService then
            TweenService:Create(self.Instance, TweenInfo.new(0.1), {
                Size = self.Size,
                Position = self.Position
            }):Play()
        else
            self.Instance.Size = self.Size
            self.Instance.Position = self.Position
        end
    end)
    
    -- Callback
    self.Instance.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        
        -- Play Solo Leveling effect
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.ZIndex = self.Instance.ZIndex + 1
        
        -- Add corner radius to ripple
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0) -- Make it circular
        corner.Parent = ripple
        
        ripple.Parent = self.Instance
        
        -- Animate ripple effect
        local buttonSize = math.max(self.Instance.AbsoluteSize.X, self.Instance.AbsoluteSize.Y) * 1.5
        
        if TweenService then
            TweenService:Create(ripple, TweenInfo.new(0.5), {
                Size = UDim2.new(0, buttonSize, 0, buttonSize),
                BackgroundTransparency = 1
            }):Play()
        else
            -- Simple animation if TweenService not available
            spawn(function()
                for i = 0, 10 do
                    ripple.Size = UDim2.new(0, buttonSize * i/10, 0, buttonSize * i/10)
                    ripple.BackgroundTransparency = 0.8 + (i/10) * 0.2
                    wait(0.05)
                end
                ripple:Destroy()
            end)
        end
        
        -- Clean up ripple
        spawn(function()
            wait(0.5)
            if ripple and ripple.Parent then
                ripple:Destroy()
            end
        end)
        
        if self.Callback then
            self.Callback()
        end
    end)
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    
    if disabled then
        self.Instance.BackgroundColor3 = self.Theme.ButtonBackground
        self.Instance.BackgroundTransparency = 0.5
        self.Instance.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        self.Instance.BackgroundColor3 = self.Theme.ButtonBackground
        self.Instance.BackgroundTransparency = 0
        self.Instance.TextColor3 = self.Theme.ButtonText
    end
end

function Button:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.ButtonBackground
    self.Instance.Font = theme.Font
    self.Instance.TextColor3 = theme.ButtonText
    self.Stroke.Color = theme.ButtonStroke or theme.AccentColor
    self.Glow.ImageColor3 = theme.AccentColor
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.ButtonGradientStart or theme.ButtonBackground),
        ColorSequenceKeypoint.new(1, theme.ButtonGradientEnd or theme.ButtonBackground)
    })
    
    -- Reset disabled state if needed
    if self.Disabled then
        self:SetDisabled(true)
    end
end

function Button:SetSize(size)
    self.Size = size
    self.Instance.Size = size
end

function Button:SetPosition(position)
    self.Position = position
    self.Instance.Position = position
end

function Button:SetText(text)
    self.Text = text
    self.Instance.Text = text
end

function Button:Destroy()
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    setmetatable(self, nil)
end

return Button