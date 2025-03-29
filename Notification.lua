--[[
    Notification Component
    Solo Leveling style notification that appears in the top-middle of the screen
]]

local TweenService = game:GetService("RunService") and game:GetService("TweenService")

local Notification = {}
Notification.__index = Notification

function Notification.new(options)
    local self = setmetatable({}, Notification)
    
    -- Default options
    options = options or {}
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Title = options.Title or "Notification"
    self.Text = options.Text or ""
    self.Duration = options.Duration or 5 -- seconds
    self.Type = options.Type or "Info" -- Info, Success, Warning, Error
    self.Callback = options.Callback
    
    -- Create the notification instance
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "Notification_" .. self.Title:gsub(" ", "_")
    self.Instance.Size = UDim2.new(0, 0, 0, 0) -- Start small for animation
    self.Instance.AnchorPoint = Vector2.new(0.5, 0)
    self.Instance.Position = UDim2.new(0.5, 0, 0, 0)
    self.Instance.BackgroundColor3 = self:_getBackgroundColor()
    self.Instance.BackgroundTransparency = 0
    self.Instance.BorderSizePixel = 0
    self.Instance.ZIndex = 1000 -- High z-index to appear on top
    self.Instance.ClipsDescendants = true
    self.Instance.AutomaticSize = Enum.AutomaticSize.None
    
    -- Add corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 6)
    self.Corner.Parent = self.Instance
    
    -- Border/Stroke (Solo Leveling style)
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self:_getAccentColor()
    self.Stroke.Thickness = 1
    self.Stroke.Transparency = 0.5
    self.Stroke.Parent = self.Instance
    
    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -50, 0, 26)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.TitleText
    self.TitleLabel.Font = self.Theme.Font
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 1001
    self.TitleLabel.Parent = self.Instance
    
    -- Message text
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "Message"
    self.TextLabel.Size = UDim2.new(1, -20, 0, 0)
    self.TextLabel.Position = UDim2.new(0, 10, 0, 35)
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Text = self.Text
    self.TextLabel.TextColor3 = self.Theme.NotificationText
    self.TextLabel.Font = self.Theme.Font
    self.TextLabel.TextSize = 16
    self.TextLabel.TextWrapped = true
    self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.TextLabel.ZIndex = 1001
    self.TextLabel.AutomaticSize = Enum.AutomaticSize.Y
    self.TextLabel.Parent = self.Instance
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = self.Theme.TitleText
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.TextSize = 20
    self.CloseButton.ZIndex = 1002
    self.CloseButton.Parent = self.Instance
    
    -- Add Solo Leveling style progress bar
    self.ProgressBar = Instance.new("Frame")
    self.ProgressBar.Name = "ProgressBar"
    self.ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    self.ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    self.ProgressBar.BackgroundColor3 = self:_getAccentColor()
    self.ProgressBar.BorderSizePixel = 0
    self.ProgressBar.ZIndex = 1003
    self.ProgressBar.Parent = self.Instance
    
    -- Add Solo Leveling glow effect
    self.Glow = Instance.new("ImageLabel")
    self.Glow.Name = "Glow"
    self.Glow.BackgroundTransparency = 1
    self.Glow.Size = UDim2.new(0, 40, 0, 40)
    self.Glow.Position = UDim2.new(0, -15, 0, -15)
    self.Glow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Glow.ImageColor3 = self:_getAccentColor()
    self.Glow.ImageTransparency = 0.7
    self.Glow.ZIndex = 999
    self.Glow.Parent = self.Instance
    
    -- Connect events
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        self.CloseButton.TextColor3 = self:_getAccentColor()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        self.CloseButton.TextColor3 = self.Theme.TitleText
    end)
    
    -- Setup auto close
    self:_setupAutoClose()
    
    -- Calculate size
    local textHeight = math.max(60, self.TextLabel.TextBounds.Y + 50) -- Minimum 60px height
    local width = math.min(500, math.max(300, self.TextLabel.TextBounds.X + 60)) -- Min 300px, max 500px width
    
    -- Animate in
    self.TargetSize = UDim2.new(0, width, 0, textHeight)
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    -- Animate in
    self:_animateIn()
    
    return self
end

function Notification:_getBackgroundColor()
    -- Get background color based on notification type
    if self.Type == "Success" then
        return self.Theme.SuccessBackground or Color3.fromRGB(40, 60, 40)
    elseif self.Type == "Warning" then
        return self.Theme.WarningBackground or Color3.fromRGB(60, 55, 30)
    elseif self.Type == "Error" then
        return self.Theme.ErrorBackground or Color3.fromRGB(60, 35, 35)
    else
        -- Info or default
        return self.Theme.NotificationBackground or self.Theme.WindowBackground
    end
end

function Notification:_getAccentColor()
    -- Get accent color based on notification type
    if self.Type == "Success" then
        return self.Theme.SuccessAccent or Color3.fromRGB(75, 200, 75)
    elseif self.Type == "Warning" then
        return self.Theme.WarningAccent or Color3.fromRGB(250, 200, 0)
    elseif self.Type == "Error" then
        return self.Theme.ErrorAccent or Color3.fromRGB(255, 75, 75)
    else
        -- Info or default
        return self.Theme.AccentColor
    end
end

function Notification:_animateIn()
    -- Initial state
    self.Instance.Size = UDim2.new(0, 0, 0, 0)
    self.Instance.Position = UDim2.new(0.5, 0, 0, 0)
    self.Instance.BackgroundTransparency = 1
    self.Stroke.Transparency = 1
    
    -- Create Solo Leveling "System Call" particles
    self:_createSystemCallEffect()
    
    -- Animate to target size
    if TweenService then
        local sizeTween = TweenService:Create(self.Instance, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = self.TargetSize,
            BackgroundTransparency = 0,
            Position = UDim2.new(0.5, 0, 0, 5) -- Slightly offset from top
        })
        
        local strokeTween = TweenService:Create(self.Stroke, TweenInfo.new(0.5), {
            Transparency = 0.5
        })
        
        sizeTween:Play()
        strokeTween:Play()
    else
        -- Fallback if TweenService not available
        self.Instance.Size = self.TargetSize
        self.Instance.BackgroundTransparency = 0
        self.Instance.Position = UDim2.new(0.5, 0, 0, 5)
        self.Stroke.Transparency = 0.5
    end
end

function Notification:_createSystemCallEffect()
    -- Create Solo Leveling style particles (blue particles rising from bottom)
    spawn(function()
        for i = 1, 10 do -- Create 10 particles
            if not self.Instance or not self.Instance.Parent then return end
            
            local particle = Instance.new("Frame")
            particle.Name = "SystemCallParticle"
            particle.Size = UDim2.new(0, 3, 0, 3)
            particle.BorderSizePixel = 0
            particle.BackgroundColor3 = self:_getAccentColor()
            particle.BackgroundTransparency = 0.3
            particle.Position = UDim2.new(math.random(), 0, 1, 10) -- Start below
            
            -- Add corner radius
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0) -- Make it circular
            corner.Parent = particle
            
            particle.Parent = self.Instance
            
            -- Animate particle rising up
            spawn(function()
                if TweenService then
                    TweenService:Create(particle, TweenInfo.new(1), {
                        Position = UDim2.new(particle.Position.X.Scale, 0, 0, -10),
                        BackgroundTransparency = 1
                    }):Play()
                else
                    -- Simple animation if TweenService not available
                    for j = 1, 10 do
                        particle.Position = UDim2.new(
                            particle.Position.X.Scale,
                            0,
                            1 - (j / 10),
                            10 - 20 * (j / 10)
                        )
                        particle.BackgroundTransparency = 0.3 + (j / 10) * 0.7
                        wait(0.05)
                    end
                end
                
                wait(1)
                if particle and particle.Parent then
                    particle:Destroy()
                end
            end)
            
            wait(0.07) -- Stagger particle creation
        end
    end)
end

function Notification:_setupAutoClose()
    spawn(function()
        if TweenService then
            -- Create progress bar tween (Solo Leveling style)
            TweenService:Create(self.ProgressBar, TweenInfo.new(self.Duration), {
                Size = UDim2.new(0, 0, 0, 2) -- Shrink to zero width
            }):Play()
        else
            -- Fallback if TweenService not available
            for i = 1, 10 do
                if not self.ProgressBar or not self.ProgressBar.Parent then return end
                wait(self.Duration / 10)
                self.ProgressBar.Size = UDim2.new(1 - (i / 10), 0, 0, 2)
            end
        end
        
        wait(self.Duration)
        if self.Instance and self.Instance.Parent then
            self:Close()
        end
    end)
end

function Notification:Close()
    -- Don't close if already closing
    if self.IsClosing then return end
    self.IsClosing = true
    
    -- Animate out
    if TweenService then
        local sizeTween = TweenService:Create(self.Instance, TweenInfo.new(0.3), {
            Size = UDim2.new(0, self.Instance.Size.X.Offset, 0, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 0)
        })
        
        sizeTween.Completed:Connect(function()
            self:Destroy()
        end)
        
        sizeTween:Play()
    else
        -- Fallback if TweenService not available
        self.Instance.Size = UDim2.new(0, self.Instance.Size.X.Offset, 0, 0)
        self.Instance.BackgroundTransparency = 1
        self.Instance.Position = UDim2.new(0.5, 0, 0, 0)
        wait(0.3)
        self:Destroy()
    end
    
    -- Fire callback
    if self.Callback then
        self.Callback()
    end
end

function Notification:Destroy()
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    
    setmetatable(self, nil)
end

function Notification:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = self:_getBackgroundColor()
    self.TitleLabel.TextColor3 = theme.TitleText
    self.TitleLabel.Font = theme.Font
    self.TextLabel.TextColor3 = theme.NotificationText
    self.TextLabel.Font = theme.Font
    self.Stroke.Color = self:_getAccentColor()
    self.ProgressBar.BackgroundColor3 = self:_getAccentColor()
    self.Glow.ImageColor3 = self:_getAccentColor()
end

return Notification
