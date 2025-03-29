--[[
    Window Component
    Solo Leveling style window with dragging and resizing
]]

local TweenService = game:GetService("RunService") and game:GetService("TweenService")
local UserInputService = game:GetService("RunService") and game:GetService("UserInputService")

-- Import other components
local Button = {}
local Frame = {}
local TextInput = {}

local function loadComponentLocally(name)
    -- Try to load component from sibling script
    if script and script.Parent and script.Parent:FindFirstChild(name) then
        local success, result = pcall(function()
            return require(script.Parent[name])
        end)
        if success then return result end
    end
    
    -- Create a minimal stub implementation
    local stub = {}
    stub.__index = stub
    stub.new = function() return setmetatable({Instance = Instance.new("Frame")}, stub) end
    stub.SetTheme = function() end
    stub.Destroy = function(self) if self.Instance then self.Instance:Destroy() end end
    
    return stub
end

local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    
    -- Load components
    Button = loadComponentLocally("Button")
    Frame = loadComponentLocally("Frame")
    TextInput = loadComponentLocally("TextInput")
    
    -- Default options
    options = options or {}
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Title = options.Title or "Window"
    self.Size = options.Size or UDim2.new(0, 500, 0, 400)
    self.Position = options.Position or UDim2.new(0.5, -250, 0.5, -200)
    self.MinimumSize = options.MinimumSize or Vector2.new(300, 200)
    self.Draggable = options.Draggable ~= false -- Default to true
    self.Resizable = options.Resizable ~= false -- Default to true
    self.CloseCallback = options.CloseCallback
    self.Elements = {}
    
    -- Create the window instance
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "Window_" .. self.Title:gsub(" ", "_")
    self.Instance.Size = self.Size
    self.Instance.Position = self.Position
    self.Instance.BackgroundColor3 = self.Theme.WindowBackground
    self.Instance.BackgroundTransparency = 0
    self.Instance.BorderSizePixel = 0
    self.Instance.ClipsDescendants = true
    
    -- Add corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 8)
    self.Corner.Parent = self.Instance
    
    -- Add drop shadow (Solo Leveling style with blue glow)
    self.Shadow = Instance.new("ImageLabel")
    self.Shadow.Name = "Shadow"
    self.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Shadow.BackgroundTransparency = 1
    self.Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Shadow.Size = UDim2.new(1, 30, 1, 30)
    self.Shadow.ZIndex = 0
    self.Shadow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Shadow.ImageColor3 = self.Theme.ShadowColor or self.Theme.AccentColor
    self.Shadow.ImageTransparency = 0.8
    self.Shadow.ScaleType = Enum.ScaleType.Slice
    self.Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    -- Add title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Theme.TitleBarBackground or self.Theme.WindowBackground
    self.TitleBar.BackgroundTransparency = 0
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.ZIndex = 2
    
    -- Add title bar top corner radius
    self.TitleBarCorner = Instance.new("UICorner")
    self.TitleBarCorner.CornerRadius = UDim.new(0, 8)
    self.TitleBarCorner.Parent = self.TitleBar
    
    -- Fix corner radius with a filler frame
    self.TitleBarFiller = Instance.new("Frame")
    self.TitleBarFiller.Name = "TitleBarFiller"
    self.TitleBarFiller.Size = UDim2.new(1, 0, 0, 10)
    self.TitleBarFiller.Position = UDim2.new(0, 0, 1, -10)
    self.TitleBarFiller.BackgroundColor3 = self.Theme.TitleBarBackground or self.Theme.WindowBackground
    self.TitleBarFiller.BackgroundTransparency = 0
    self.TitleBarFiller.BorderSizePixel = 0
    self.TitleBarFiller.ZIndex = 2
    self.TitleBarFiller.Parent = self.TitleBar
    
    -- Title text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(1, -120, 1, 0)
    self.TitleText.Position = UDim2.new(0, 15, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Theme.TitleText
    self.TitleText.Font = self.Theme.Font
    self.TitleText.TextSize = 18
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.ZIndex = 3
    self.TitleText.Parent = self.TitleBar
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -40, 0, 5)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = self.Theme.TitleText
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.TextSize = 24
    self.CloseButton.ZIndex = 3
    self.CloseButton.Parent = self.TitleBar
    
    -- Add Solo Leveling style blue accent to title bar
    self.TitleAccent = Instance.new("Frame")
    self.TitleAccent.Name = "TitleAccent"
    self.TitleAccent.Size = UDim2.new(1, 0, 0, 1)
    self.TitleAccent.Position = UDim2.new(0, 0, 1, 0)
    self.TitleAccent.BackgroundColor3 = self.Theme.AccentColor
    self.TitleAccent.BorderSizePixel = 0
    self.TitleAccent.ZIndex = 3
    self.TitleAccent.Parent = self.TitleBar
    
    -- Content container
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -50)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 45)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = self.Theme.AccentColor
    self.ContentFrame.ZIndex = 2
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- Add content layout
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.Padding = UDim.new(0, 10)
    self.ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Parent = self.ContentFrame
    
    -- Add padding
    self.ContentPadding = Instance.new("UIPadding")
    self.ContentPadding.PaddingTop = UDim.new(0, 5)
    self.ContentPadding.PaddingLeft = UDim.new(0, 5)
    self.ContentPadding.PaddingRight = UDim.new(0, 5)
    self.ContentPadding.PaddingBottom = UDim.new(0, 5)
    self.ContentPadding.Parent = self.ContentFrame
    
    -- Add resize handle (only visible if window is resizable)
    if self.Resizable then
        self.ResizeHandle = Instance.new("TextButton")
        self.ResizeHandle.Name = "ResizeHandle"
        self.ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
        self.ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
        self.ResizeHandle.BackgroundTransparency = 1
        self.ResizeHandle.Text = ""
        self.ResizeHandle.ZIndex = 10
        
        -- Resize handle icon
        self.ResizeIcon = Instance.new("ImageLabel")
        self.ResizeIcon.Name = "ResizeIcon"
        self.ResizeIcon.Size = UDim2.new(1, 0, 1, 0)
        self.ResizeIcon.BackgroundTransparency = 1
        self.ResizeIcon.Image = "rbxassetid://7059346373" -- Default resize icon
        self.ResizeIcon.ImageColor3 = self.Theme.AccentColor
        self.ResizeIcon.ImageTransparency = 0.6
        self.ResizeIcon.ZIndex = 10
        self.ResizeIcon.Parent = self.ResizeHandle
        
        self.ResizeHandle.Parent = self.Instance
    end
    
    -- Border/Stroke 
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.WindowStroke or self.Theme.AccentColor
    self.Stroke.Thickness = 1
    self.Stroke.Transparency = 0.7
    self.Stroke.Parent = self.Instance
    
    -- Add Solo Leveling style glow effect to top-right corner
    self.TopRightGlow = Instance.new("ImageLabel")
    self.TopRightGlow.Name = "CornerGlow"
    self.TopRightGlow.BackgroundTransparency = 1
    self.TopRightGlow.Position = UDim2.new(1, -60, 0, -20)
    self.TopRightGlow.Size = UDim2.new(0, 100, 0, 100)
    self.TopRightGlow.Image = "rbxassetid://5028857084" -- Circular glow
    self.TopRightGlow.ImageColor3 = self.Theme.AccentColor
    self.TopRightGlow.ImageTransparency = 0.7
    self.TopRightGlow.ZIndex = 1
    self.TopRightGlow.Parent = self.Instance
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent hierarchy
    self.TitleBar.Parent = self.Instance
    self.ContentFrame.Parent = self.Instance
    self.Shadow.Parent = self.Instance
    
    -- Set parent
    if self.Parent then
        self.Instance.Parent = self.Parent
    end
    
    -- Create particles effect (Solo Leveling blue particles)
    self:_createParticles()
    
    return self
end

function Window:_connectEvents()
    -- Close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        self.CloseButton.TextColor3 = self.Theme.AccentColor
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        self.CloseButton.TextColor3 = self.Theme.TitleText
    end)
    
    -- Window dragging
    if self.Draggable and self.TitleBar and UserInputService then
        local dragging = false
        local dragInput, mousePos, framePos
        
        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = input.Position
                framePos = self.Instance.Position
            end
        end)
        
        self.TitleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        spawn(function()
            while self.Instance and self.Instance.Parent do
                if dragging and dragInput and mousePos then
                    local delta = dragInput.Position - mousePos
                    self.Instance.Position = UDim2.new(
                        framePos.X.Scale,
                        framePos.X.Offset + delta.X,
                        framePos.Y.Scale,
                        framePos.Y.Offset + delta.Y
                    )
                end
                wait()
            end
        end)
    end
    
    -- Window resizing
    if self.Resizable and self.ResizeHandle and UserInputService then
        local resizing = false
        local startPos, startSize
        
        self.ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                startPos = input.Position
                startSize = self.Instance.Size
            end
        end)
        
        self.ResizeHandle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startPos
                local newWidth = math.max(self.MinimumSize.X, startSize.X.Offset + delta.X)
                local newHeight = math.max(self.MinimumSize.Y, startSize.Y.Offset + delta.Y)
                
                self.Instance.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end)
    end
end

function Window:_createParticles()
    -- Solo Leveling blue particles effect
    spawn(function()
        while self.Instance and self.Instance.Parent do
            -- Create a particle
            local particle = Instance.new("Frame")
            particle.Name = "Particle"
            particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            particle.BorderSizePixel = 0
            
            -- Solo Leveling style - mostly blue but occasional purple particle (Shadow monarch hint)
            if math.random() < 0.85 then
                particle.BackgroundColor3 = self.Theme.AccentColor
            else
                particle.BackgroundColor3 = Color3.fromRGB(150, 0, 255) -- Purple for Shadow Monarch
            end
            
            particle.BackgroundTransparency = 0.7
            particle.Position = UDim2.new(math.random(), 0, 1, 5)
            
            -- Add corner radius
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0) -- Make it circular
            corner.Parent = particle
            
            particle.Parent = self.Instance
            
            -- Animate particle rising up
            spawn(function()
                local duration = math.random(5, 10)
                local startTime = tick()
                
                local startX = particle.Position.X.Scale
                local wobbleSpeed = math.random(10, 30) / 10
                local wobbleAmount = math.random(5, 20) / 1000
                
                while particle and particle.Parent and (tick() - startTime) < duration do
                    local elapsed = tick() - startTime
                    local progress = elapsed / duration
                    
                    -- Apply rising motion with slight wobble
                    local wobble = math.sin(elapsed * wobbleSpeed) * wobbleAmount
                    
                    particle.Position = UDim2.new(
                        startX + wobble,
                        particle.Position.X.Offset,
                        1 - progress,
                        5
                    )
                    
                    -- Fade out gradually
                    particle.BackgroundTransparency = 0.7 + (progress * 0.3)
                    
                    wait()
                end
                
                if particle and particle.Parent then
                    particle:Destroy()
                end
            end)
            
            -- Delay between particles
            wait(math.random(1, 3))
        end
    end)
end

function Window:CreateButton(options)
    options = options or {}
    options.Parent = self.ContentFrame
    options.Theme = options.Theme or self.Theme
    options.Size = options.Size or UDim2.new(1, -10, 0, 40)
    
    local newButton = Button.new(options)
    table.insert(self.Elements, newButton)
    
    return newButton
end

function Window:CreateFrame(options)
    options = options or {}
    options.Parent = self.ContentFrame
    options.Theme = options.Theme or self.Theme
    options.Size = options.Size or UDim2.new(1, -10, 0, 150)
    
    local newFrame = Frame.new(options)
    table.insert(self.Elements, newFrame)
    
    return newFrame
end

function Window:CreateTextInput(options)
    options = options or {}
    options.Parent = self.ContentFrame
    options.Theme = options.Theme or self.Theme
    options.Size = options.Size or UDim2.new(1, -10, 0, 35)
    
    local newTextInput = TextInput.new(options)
    table.insert(self.Elements, newTextInput)
    
    return newTextInput
end

function Window:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.WindowBackground
    self.TitleBar.BackgroundColor3 = theme.TitleBarBackground or theme.WindowBackground
    self.TitleBarFiller.BackgroundColor3 = theme.TitleBarBackground or theme.WindowBackground
    self.TitleText.TextColor3 = theme.TitleText
    self.TitleAccent.BackgroundColor3 = theme.AccentColor
    self.ContentFrame.ScrollBarImageColor3 = theme.AccentColor
    self.Shadow.ImageColor3 = theme.ShadowColor or theme.AccentColor
    self.Stroke.Color = theme.WindowStroke or theme.AccentColor
    self.TopRightGlow.ImageColor3 = theme.AccentColor
    
    if self.ResizeIcon then
        self.ResizeIcon.ImageColor3 = theme.AccentColor
    end
    
    -- Update all elements
    for _, element in ipairs(self.Elements) do
        if element.SetTheme then
            element:SetTheme(theme)
        end
    end
end

function Window:SetSize(size)
    self.Size = size
    self.Instance.Size = size
end

function Window:SetPosition(position)
    self.Position = position
    self.Instance.Position = position
end

function Window:SetTitle(title)
    self.Title = title
    self.TitleText.Text = title
    self.Instance.Name = "Window_" .. title:gsub(" ", "_")
end

function Window:Close()
    -- Fire close callback
    if self.CloseCallback then
        self.CloseCallback()
    end
    
    -- Add Solo Leveling close animation with particles
    if TweenService then
        -- Create burst particles
        for i = 1, 20 do
            local particle = Instance.new("Frame")
            particle.Name = "CloseParticle"
            particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
            particle.BorderSizePixel = 0
            particle.BackgroundColor3 = self.Theme.AccentColor
            particle.BackgroundTransparency = 0.5
            particle.AnchorPoint = Vector2.new(0.5, 0.5)
            particle.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            -- Add corner radius
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0) -- Make it circular
            corner.Parent = particle
            
            particle.Parent = self.Instance
            
            -- Animate particle outward
            local angle = math.rad(math.random(0, 360))
            local distance = math.random(100, 300)
            local speed = math.random(5, 15) / 10
            
            spawn(function()
                TweenService:Create(particle, TweenInfo.new(speed), {
                    Position = UDim2.new(
                        0.5, math.cos(angle) * distance,
                        0.5, math.sin(angle) * distance
                    ),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
                
                wait(speed)
                if particle and particle.Parent then
                    particle:Destroy()
                end
            end)
        end
        
        -- Animate window
        TweenService:Create(self.Instance, TweenInfo.new(0.5), {
            Size = UDim2.new(0, self.Instance.Size.X.Offset * 0.8, 0, self.Instance.Size.Y.Offset * 0.8),
            Position = UDim2.new(
                self.Instance.Position.X.Scale,
                self.Instance.Position.X.Offset + self.Instance.Size.X.Offset * 0.1,
                self.Instance.Position.Y.Scale,
                self.Instance.Position.Y.Offset + self.Instance.Size.Y.Offset * 0.1
            ),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(self.TitleText, TweenInfo.new(0.3), {
            TextTransparency = 1
        }):Play()
        
        TweenService:Create(self.TitleAccent, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(self.Shadow, TweenInfo.new(0.5), {
            ImageTransparency = 1
        }):Play()
        
        -- Destroy after animation
        spawn(function()
            wait(0.5)
            self:Destroy()
        end)
    else
        -- Fallback without animations
        self:Destroy()
    end
end

function Window:Destroy()
    -- Destroy all elements
    for _, element in ipairs(self.Elements) do
        if element.Destroy then
            element:Destroy()
        end
    end
    
    -- Clear elements table
    self.Elements = {}
    
    -- Destroy window instance
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    
    -- Clear metatable
    setmetatable(self, nil)
end

return Window
