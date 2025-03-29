--[[
    TextInput Component
    Solo Leveling style text input with glowing effects
]]

local TweenService = game:GetService("RunService") and game:GetService("TweenService")
local UserInputService = game:GetService("RunService") and game:GetService("UserInputService")

local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(options)
    local self = setmetatable({}, TextInput)
    
    -- Default options
    options = options or {}
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Size = options.Size or UDim2.new(0, 200, 0, 35)
    self.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.PlaceholderText = options.PlaceholderText or "Enter text..."
    self.DefaultText = options.DefaultText or ""
    self.Callback = options.Callback
    self.ZIndex = options.ZIndex or 1
    self.TextOnly = options.TextOnly
    self.NumbersOnly = options.NumbersOnly
    
    -- Create the container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = "TextInput_Container"
    self.Container.Size = self.Size
    self.Container.Position = self.Position
    self.Container.BackgroundColor3 = self.Theme.InputBackground or Color3.fromRGB(30, 35, 45)
    self.Container.BackgroundTransparency = 0
    self.Container.BorderSizePixel = 0
    self.Container.ZIndex = self.ZIndex
    
    -- Add corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 4)
    self.Corner.Parent = self.Container
    
    -- Border/Stroke 
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.InputStroke or self.Theme.AccentColor
    self.Stroke.Thickness = 1
    self.Stroke.Transparency = 0.7
    self.Stroke.Parent = self.Container
    
    -- Create the text box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "TextInput"
    self.InputBox.Size = UDim2.new(1, -20, 1, 0)
    self.InputBox.Position = UDim2.new(0, 10, 0, 0)
    self.InputBox.BackgroundTransparency = 1
    self.InputBox.PlaceholderText = self.PlaceholderText
    self.InputBox.PlaceholderColor3 = self.Theme.InputPlaceholderText or Color3.fromRGB(120, 120, 130)
    self.InputBox.Text = self.DefaultText
    self.InputBox.TextColor3 = self.Theme.InputText or Color3.fromRGB(200, 200, 210)
    self.InputBox.Font = self.Theme.Font
    self.InputBox.TextSize = 16
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.ClipsDescendants = true
    self.InputBox.ZIndex = self.ZIndex + 1
    self.InputBox.Parent = self.Container
    
    -- Shadow Monarch style effect for focused state
    self.FocusEffect = Instance.new("Frame")
    self.FocusEffect.Name = "FocusEffect"
    self.FocusEffect.Size = UDim2.new(0, 4, 0, 0)
    self.FocusEffect.AnchorPoint = Vector2.new(0, 0.5)
    self.FocusEffect.Position = UDim2.new(0, 0, 0.5, 0)
    self.FocusEffect.BackgroundColor3 = self.Theme.AccentColor
    self.FocusEffect.BorderSizePixel = 0
    self.FocusEffect.Visible = false
    self.FocusEffect.ZIndex = self.ZIndex + 1
    self.FocusEffect.Parent = self.Container
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent
    if self.Parent then
        self.Container.Parent = self.Parent
    end
    
    return self
end

function TextInput:_connectEvents()
    -- Text changed callback
    self.InputBox.Changed:Connect(function(property)
        if property == "Text" then
            -- Filter for text or numbers only if specified
            if self.TextOnly then
                self.InputBox.Text = self.InputBox.Text:gsub("%d", "")
            elseif self.NumbersOnly then
                self.InputBox.Text = self.InputBox.Text:gsub("%D", "")
            end
            
            if self.Callback then
                self.Callback(self.InputBox.Text)
            end
        end
    end)
    
    -- Focused effect
    self.InputBox.Focused:Connect(function()
        self.FocusEffect.Visible = true
        
        if TweenService then
            -- Solo Leveling style focus animation
            TweenService:Create(self.Stroke, TweenInfo.new(0.3), {
                Transparency = 0,
                Color = self.Theme.AccentColor
            }):Play()
            
            TweenService:Create(self.FocusEffect, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 4, 1, -4)
            }):Play()
        else
            self.Stroke.Transparency = 0
            self.Stroke.Color = self.Theme.AccentColor
            self.FocusEffect.Size = UDim2.new(0, 4, 1, -4)
        end
        
        -- Create particle effect (for Solo Leveling feel)
        spawn(function()
            for i = 1, 3 do
                local particle = Instance.new("Frame")
                particle.Name = "FocusParticle"
                particle.Size = UDim2.new(0, 3, 0, 3)
                particle.BorderSizePixel = 0
                particle.BackgroundColor3 = self.Theme.AccentColor
                particle.BackgroundTransparency = 0.5
                particle.Position = UDim2.new(0, math.random(5, self.Container.AbsoluteSize.X - 5), 0, self.Container.AbsoluteSize.Y)
                
                -- Add corner radius
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0) -- Make it circular
                corner.Parent = particle
                
                particle.Parent = self.Container
                
                -- Animate particle rising up
                spawn(function()
                    if TweenService then
                        TweenService:Create(particle, TweenInfo.new(0.5), {
                            Position = UDim2.new(particle.Position.X.Scale, particle.Position.X.Offset, 0, 0),
                            BackgroundTransparency = 1
                        }):Play()
                    else
                        -- Simple animation if TweenService not available
                        for j = 1, 10 do
                            particle.Position = UDim2.new(
                                particle.Position.X.Scale,
                                particle.Position.X.Offset,
                                0,
                                self.Container.AbsoluteSize.Y - (j / 10) * self.Container.AbsoluteSize.Y
                            )
                            particle.BackgroundTransparency = 0.5 + (j / 10) * 0.5
                            wait(0.05)
                        end
                    end
                    
                    wait(0.5)
                    if particle and particle.Parent then
                        particle:Destroy()
                    end
                end)
                
                wait(0.1)
            end
        end)
    end)
    
    -- Unfocused effect
    self.InputBox.FocusLost:Connect(function(enterPressed, inputObject)
        if TweenService then
            TweenService:Create(self.Stroke, TweenInfo.new(0.3), {
                Transparency = 0.7,
                Color = self.Theme.InputStroke or self.Theme.AccentColor
            }):Play()
            
            TweenService:Create(self.FocusEffect, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 4, 0, 0)
            }):Play()
        else
            self.Stroke.Transparency = 0.7
            self.Stroke.Color = self.Theme.InputStroke or self.Theme.AccentColor
            self.FocusEffect.Size = UDim2.new(0, 4, 0, 0)
        end
        
        -- Hide the focus effect after animation
        spawn(function()
            wait(0.2)
            self.FocusEffect.Visible = false
        end)
        
        -- Handle Enter key
        if enterPressed and self.Callback then
            self.Callback(self.InputBox.Text, true) -- second parameter indicates Enter was pressed
        end
    end)
end

function TextInput:GetText()
    return self.InputBox.Text
end

function TextInput:SetText(text)
    self.InputBox.Text = text or ""
end

function TextInput:SetPlaceholderText(text)
    self.PlaceholderText = text
    self.InputBox.PlaceholderText = text
end

function TextInput:SetTheme(theme)
    self.Theme = theme
    
    self.Container.BackgroundColor3 = theme.InputBackground or Color3.fromRGB(30, 35, 45)
    self.Stroke.Color = theme.InputStroke or theme.AccentColor
    self.InputBox.TextColor3 = theme.InputText or Color3.fromRGB(200, 200, 210)
    self.InputBox.PlaceholderColor3 = theme.InputPlaceholderText or Color3.fromRGB(120, 120, 130)
    self.InputBox.Font = theme.Font
    self.FocusEffect.BackgroundColor3 = theme.AccentColor
end

function TextInput:SetSize(size)
    self.Size = size
    self.Container.Size = size
end

function TextInput:SetPosition(position)
    self.Position = position
    self.Container.Position = position
end

function TextInput:Destroy()
    if self.Container then
        self.Container:Destroy()
        self.Container = nil
    end
    setmetatable(self, nil)
end

return TextInput