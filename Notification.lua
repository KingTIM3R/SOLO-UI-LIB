--[[
    Notification Component
    Solo Leveling style notification that appears in the top-middle
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Notification = {}
Notification.__index = Notification

function Notification.new(options)
    local self = setmetatable({}, Notification)
    
    -- Default options
    options = options or {}
    self.Title = options.Title or "Notification"
    self.Text = options.Text or "This is a notification"
    self.Duration = options.Duration or 5
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Icon = options.Icon
    self.Callback = options.Callback
    
    -- Create the notification frame
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "Notification_" .. self.Title:gsub(" ", "_")
    self.Instance.Size = UDim2.new(0, 300, 0, 80)
    self.Instance.Position = UDim2.new(0.5, 0, 0, 0)
    self.Instance.AnchorPoint = Vector2.new(0.5, 0)
    self.Instance.BackgroundColor3 = self.Theme.NotificationBackground
    self.Instance.BackgroundTransparency = 0.1
    self.Instance.BorderSizePixel = 0
    self.Instance.ZIndex = 10
    self.Instance.Visible = false
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 6)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.AccentColor
    self.Stroke.Thickness = 2
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.NotificationGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.NotificationGradientEnd)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Text = self.Title
    self.TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Font = self.Theme.Font
    self.TitleLabel.TextColor3 = self.Theme.NotificationTitle
    self.TitleLabel.TextSize = self.Theme.TitleTextSize
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 11
    self.TitleLabel.Parent = self.Instance
    
    -- Description
    self.DescriptionLabel = Instance.new("TextLabel")
    self.DescriptionLabel.Name = "Description"
    self.DescriptionLabel.Text = self.Text
    self.DescriptionLabel.Size = UDim2.new(1, -20, 0, 40)
    self.DescriptionLabel.Position = UDim2.new(0, 10, 0, 35)
    self.DescriptionLabel.BackgroundTransparency = 1
    self.DescriptionLabel.Font = self.Theme.Font
    self.DescriptionLabel.TextColor3 = self.Theme.NotificationText
    self.DescriptionLabel.TextSize = self.Theme.BodyTextSize
    self.DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescriptionLabel.TextWrapped = true
    self.DescriptionLabel.ZIndex = 11
    self.DescriptionLabel.Parent = self.Instance
    
    -- Progress bar (for duration)
    self.ProgressBar = Instance.new("Frame")
    self.ProgressBar.Name = "ProgressBar"
    self.ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    self.ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    self.ProgressBar.BackgroundColor3 = self.Theme.AccentColor
    self.ProgressBar.BorderSizePixel = 0
    self.ProgressBar.ZIndex = 12
    self.ProgressBar.Parent = self.Instance
    
    -- Glow Effect
    self.Glow = Instance.new("ImageLabel")
    self.Glow.Name = "Glow"
    self.Glow.BackgroundTransparency = 1
    self.Glow.Size = UDim2.new(1, 20, 1, 20)
    self.Glow.Position = UDim2.new(0, -10, 0, -10)
    self.Glow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Glow.ImageColor3 = self.Theme.AccentColor
    self.Glow.ImageTransparency = 0.8
    self.Glow.ZIndex = 9
    self.Glow.Parent = self.Instance
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Text = "×"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 5)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Font = self.Theme.Font
    self.CloseButton.TextColor3 = self.Theme.NotificationText
    self.CloseButton.TextSize = 20
    self.CloseButton.ZIndex = 12
    self.CloseButton.Parent = self.Instance
    
    -- Add icon if provided
    if self.Icon then
        self.IconImage = Instance.new("ImageLabel")
        self.IconImage.Name = "Icon"
        self.IconImage.Size = UDim2.new(0, 24, 0, 24)
        self.IconImage.Position = UDim2.new(0, 10, 0, 8)
        self.IconImage.BackgroundTransparency = 1
        self.IconImage.Image = self.Icon
        self.IconImage.ZIndex = 12
        self.IconImage.Parent = self.Instance
        
        -- Adjust title position
        self.TitleLabel.Position = UDim2.new(0, 44, 0, 5)
        self.TitleLabel.Size = UDim2.new(1, -54, 0, 30)
    end
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
        self:Show()
    end
    
    return self
end

function Notification:_connectEvents()
    -- Close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    -- Callback on click
    if self.Callback then
        self.Instance.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.Callback()
            end
        end)
    end
end

function Notification:Show()
    -- Set visibility
    self.Instance.Visible = true
    
    -- Initial position (offscreen)
    self.Instance.Position = UDim2.new(0.5, 0, 0, -self.Instance.AbsoluteSize.Y)
    
    -- Animate in
    local appearTween = TweenService:Create(self.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, 0)
    })
    appearTween:Play()
    
    -- Add blue glow effect when appearing
    local glowTween = TweenService:Create(self.Glow, TweenInfo.new(0.5), {
        ImageTransparency = 0.6
    })
    glowTween:Play()
    
    -- Progress bar animation
    local progressTween = TweenService:Create(self.ProgressBar, TweenInfo.new(self.Duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    progressTween:Play()
    
    -- Hide after duration
    spawn(function()
        wait(self.Duration)
        -- Only hide if not already hidden
        if self.Instance.Visible then
            self:Hide()
        end
    end)
end

function Notification:Hide()
    if not self.Instance or not self.Instance.Parent then return end
    
    -- Animate out
    local disappearTween = TweenService:Create(self.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1.5, 0, 0, 0),
        BackgroundTransparency = 1
    })
    
    disappearTween.Completed:Connect(function()
        self:Destroy()
    end)
    
    disappearTween:Play()
end

function Notification:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.NotificationBackground
    self.TitleLabel.Font = theme.Font
    self.TitleLabel.TextColor3 = theme.NotificationTitle
    self.TitleLabel.TextSize = theme.TitleTextSize
    self.DescriptionLabel.Font = theme.Font
    self.DescriptionLabel.TextColor3 = theme.NotificationText
    self.DescriptionLabel.TextSize = theme.BodyTextSize
    self.ProgressBar.BackgroundColor3 = theme.AccentColor
    self.Glow.ImageColor3 = theme.AccentColor
    self.Stroke.Color = theme.AccentColor
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.NotificationGradientStart),
        ColorSequenceKeypoint.new(1, theme.NotificationGradientEnd)
    })
end

function Notification:Destroy()
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    setmetatable(self, nil)
end

return Notification
