--[[
    Frame Component
    Solo Leveling style panel with effects
]]

local TweenService = game:GetService("RunService") and game:GetService("TweenService")

local Frame = {}
Frame.__index = Frame

function Frame.new(options)
    local self = setmetatable({}, Frame)
    
    -- Default options
    options = options or {}
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Size = options.Size or UDim2.new(0, 200, 0, 150)
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Title = options.Title
    self.ZIndex = options.ZIndex or 1
    
    -- Create the frame
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "Frame_" .. (self.Title and self.Title:gsub(" ", "_") or "Untitled")
    self.Instance.Size = self.Size
    self.Instance.Position = self.Position
    self.Instance.BackgroundColor3 = self.Theme.FrameBackground or self.Theme.WindowBackground
    self.Instance.BackgroundTransparency = 0
    self.Instance.BorderSizePixel = 0
    self.Instance.ZIndex = self.ZIndex
    
    -- Add corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 6)
    self.Corner.Parent = self.Instance
    
    -- Border/Stroke 
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.FrameStroke or self.Theme.AccentColor
    self.Stroke.Thickness = 1
    self.Stroke.Transparency = 0.5
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect (Solo Leveling style)
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.FrameGradientStart or self.Theme.FrameBackground or self.Theme.WindowBackground),
        ColorSequenceKeypoint.new(1, self.Theme.FrameGradientEnd or self.Theme.FrameBackground or self.Theme.WindowBackground)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Add title if provided
    if self.Title then
        self.TitleLabel = Instance.new("TextLabel")
        self.TitleLabel.Name = "Title"
        self.TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        self.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        self.TitleLabel.BackgroundTransparency = 1
        self.TitleLabel.Text = self.Title
        self.TitleLabel.TextColor3 = self.Theme.TitleText
        self.TitleLabel.Font = self.Theme.Font
        self.TitleLabel.TextSize = 18
        self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.TitleLabel.ZIndex = self.ZIndex + 1
        self.TitleLabel.Parent = self.Instance
        
        -- Add title underline (Solo Leveling style)
        self.TitleUnderline = Instance.new("Frame")
        self.TitleUnderline.Name = "TitleUnderline"
        self.TitleUnderline.Size = UDim2.new(1, -20, 0, 1)
        self.TitleUnderline.Position = UDim2.new(0, 10, 0, 35)
        self.TitleUnderline.BackgroundColor3 = self.Theme.AccentColor
        self.TitleUnderline.BorderSizePixel = 0
        self.TitleUnderline.ZIndex = self.ZIndex + 1
        self.TitleUnderline.Parent = self.Instance
        
        -- Content padding
        self.ContentPadding = Instance.new("UIPadding")
        self.ContentPadding.PaddingTop = UDim.new(0, 40)
        self.ContentPadding.PaddingLeft = UDim.new(0, 10)
        self.ContentPadding.PaddingRight = UDim.new(0, 10)
        self.ContentPadding.PaddingBottom = UDim.new(0, 10)
        self.ContentPadding.Parent = self.Instance
    else
        -- Content padding (without title)
        self.ContentPadding = Instance.new("UIPadding")
        self.ContentPadding.PaddingTop = UDim.new(0, 10)
        self.ContentPadding.PaddingLeft = UDim.new(0, 10)
        self.ContentPadding.PaddingRight = UDim.new(0, 10)
        self.ContentPadding.PaddingBottom = UDim.new(0, 10)
        self.ContentPadding.Parent = self.Instance
    end
    
    -- Add corner glow effect (Solo Leveling style)
    self.TopRightGlow = Instance.new("ImageLabel")
    self.TopRightGlow.Name = "CornerGlow"
    self.TopRightGlow.BackgroundTransparency = 1
    self.TopRightGlow.Position = UDim2.new(1, -30, 0, -10)
    self.TopRightGlow.Size = UDim2.new(0, 40, 0, 40)
    self.TopRightGlow.Image = "rbxassetid://5028857084" -- Circular glow
    self.TopRightGlow.ImageColor3 = self.Theme.AccentColor
    self.TopRightGlow.ImageTransparency = 0.7
    self.TopRightGlow.ZIndex = self.ZIndex - 1
    self.TopRightGlow.Parent = self.Instance
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    return self
end

function Frame:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.FrameBackground or theme.WindowBackground
    self.Stroke.Color = theme.FrameStroke or theme.AccentColor
    self.TopRightGlow.ImageColor3 = theme.AccentColor
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.FrameGradientStart or theme.FrameBackground or theme.WindowBackground),
        ColorSequenceKeypoint.new(1, theme.FrameGradientEnd or theme.FrameBackground or theme.WindowBackground)
    })
    
    if self.TitleLabel then
        self.TitleLabel.TextColor3 = theme.TitleText
        self.TitleLabel.Font = theme.Font
        self.TitleUnderline.BackgroundColor3 = theme.AccentColor
    end
end

function Frame:SetSize(size)
    self.Size = size
    self.Instance.Size = size
end

function Frame:SetPosition(position)
    self.Position = position
    self.Instance.Position = position
end

function Frame:SetTitle(title)
    if not self.TitleLabel then
        -- Create title elements if they don't exist
        self.TitleLabel = Instance.new("TextLabel")
        self.TitleLabel.Name = "Title"
        self.TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        self.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        self.TitleLabel.BackgroundTransparency = 1
        self.TitleLabel.TextColor3 = self.Theme.TitleText
        self.TitleLabel.Font = self.Theme.Font
        self.TitleLabel.TextSize = 18
        self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.TitleLabel.ZIndex = self.ZIndex + 1
        self.TitleLabel.Parent = self.Instance
        
        self.TitleUnderline = Instance.new("Frame")
        self.TitleUnderline.Name = "TitleUnderline"
        self.TitleUnderline.Size = UDim2.new(1, -20, 0, 1)
        self.TitleUnderline.Position = UDim2.new(0, 10, 0, 35)
        self.TitleUnderline.BackgroundColor3 = self.Theme.AccentColor
        self.TitleUnderline.BorderSizePixel = 0
        self.TitleUnderline.ZIndex = self.ZIndex + 1
        self.TitleUnderline.Parent = self.Instance
        
        -- Update content padding
        self.ContentPadding.PaddingTop = UDim.new(0, 40)
    end
    
    self.Title = title
    self.TitleLabel.Text = title
    self.Instance.Name = "Frame_" .. title:gsub(" ", "_")
end

function Frame:AddChild(child)
    if typeof(child) == "Instance" then
        child.Parent = self.Instance
    elseif child.Instance then
        child.Instance.Parent = self.Instance
    end
end

function Frame:Destroy()
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    setmetatable(self, nil)
end

return Frame