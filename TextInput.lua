--[[
    TextInput Component
    A customizable text input field in Solo Leveling style
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(options)
    local self = setmetatable({}, TextInput)
    
    -- Default options
    options = options or {}
    self.Name = options.Name or "TextInput"
    self.PlaceholderText = options.PlaceholderText or "Enter text..."
    self.Text = options.Text or ""
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Size = options.Size or UDim2.new(0, 200, 0, 40)
    self.AnchorPoint = options.AnchorPoint or Vector2.new(0, 0)
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Callback = options.Callback or function() end
    self.ClearTextOnFocus = options.ClearTextOnFocus == nil and true or options.ClearTextOnFocus
    self.MultiLine = options.MultiLine or false
    
    -- Create the base frame
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name
    self.Instance.Position = self.Position
    self.Instance.Size = self.Size
    self.Instance.AnchorPoint = self.AnchorPoint
    self.Instance.BackgroundColor3 = self.Theme.InputBackground
    self.Instance.BorderSizePixel = 0
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 4)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.InputStroke
    self.Stroke.Thickness = 1
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.InputGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.InputGradientEnd)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Create the text box
    self.TextBox = Instance.new(self.MultiLine and "TextBox" or "TextBox")
    self.TextBox.Name = "TextBox"
    self.TextBox.Text = self.Text
    self.TextBox.PlaceholderText = self.PlaceholderText
    self.TextBox.Size = UDim2.new(1, -16, 1, -8)
    self.TextBox.Position = UDim2.new(0, 8, 0, 4)
    self.TextBox.BackgroundTransparency = 1
    self.TextBox.Font = self.Theme.Font
    self.TextBox.TextColor3 = self.Theme.InputText
    self.TextBox.PlaceholderColor3 = self.Theme.InputPlaceholder
    self.TextBox.TextSize = self.Theme.InputTextSize
    self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
    self.TextBox.TextYAlignment = Enum.TextYAlignment.Center
    self.TextBox.ClearTextOnFocus = self.ClearTextOnFocus
    self.TextBox.MultiLine = self.MultiLine
    self.TextBox.Parent = self.Instance
    
    -- Accent bar (underline)
    self.AccentBar = Instance.new("Frame")
    self.AccentBar.Name = "AccentBar"
    self.AccentBar.Size = UDim2.new(0, 0, 0, 2)
    self.AccentBar.Position = UDim2.new(0, 0, 1, -2)
    self.AccentBar.BackgroundColor3 = self.Theme.AccentColor
    self.AccentBar.BorderSizePixel = 0
    self.AccentBar.ZIndex = 2
    self.AccentBar.Parent = self.Instance
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    return self
end

function TextInput:_connectEvents()
    -- Focus events
    self.TextBox.Focused:Connect(function()
        -- Expand accent bar
        TweenService:Create(self.AccentBar, TweenInfo.new(0.3), {
            Size = UDim2.new(1, 0, 0, 2)
        }):Play()
        
        -- Change border color
        TweenService:Create(self.Stroke, TweenInfo.new(0.3), {
            Color = self.Theme.AccentColor,
            Thickness = 2
        }):Play()
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        -- Shrink accent bar
        TweenService:Create(self.AccentBar, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 2)
        }):Play()
        
        -- Reset border color
        TweenService:Create(self.Stroke, TweenInfo.new(0.3), {
            Color = self.Theme.InputStroke,
            Thickness = 1
        }):Play()
        
        -- Call callback
        if enterPressed then
            self.Callback(self.TextBox.Text)
        end
    end)
    
    -- Text changed event
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.Text = self.TextBox.Text
    end)
    
    -- Click event
    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.TextBox:CaptureFocus()
        end
    end)
end

function TextInput:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.InputBackground
    self.TextBox.Font = theme.Font
    self.TextBox.TextColor3 = theme.InputText
    self.TextBox.PlaceholderColor3 = theme.InputPlaceholder
    self.TextBox.TextSize = theme.InputTextSize
    self.AccentBar.BackgroundColor3 = theme.AccentColor
    self.Stroke.Color = theme.InputStroke
    
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.InputGradientStart),
        ColorSequenceKeypoint.new(1, theme.InputGradientEnd)
    })
end

function TextInput:SetText(text)
    self.Text = text
    self.TextBox.Text = text
end

function TextInput:GetText()
    return self.TextBox.Text
end

function TextInput:SetPlaceholderText(text)
    self.PlaceholderText = text
    self.TextBox.PlaceholderText = text
end

function TextInput:SetCallback(callback)
    self.Callback = callback
end

function TextInput:SetVisible(visible)
    self.Instance.Visible = visible
end

function TextInput:Destroy()
    self.Instance:Destroy()
    setmetatable(self, nil)
end

return TextInput
