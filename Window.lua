--[[
    Window Component
    A resizable window with Solo Leveling aesthetics
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    
    -- Default options
    options = options or {}
    self.Name = options.Name or "Window"
    self.Title = options.Title or "Solo Leveling UI"
    self.Position = options.Position or UDim2.new(0.5, 0, 0.5, 0)
    self.Size = options.Size or UDim2.new(0, 500, 0, 350)
    self.MinSize = options.MinSize or Vector2.new(300, 200)
    self.MaxSize = options.MaxSize
    self.AnchorPoint = options.AnchorPoint or Vector2.new(0.5, 0.5)
    self.Parent = options.Parent
    self.Theme = options.Theme
    self.Draggable = options.Draggable ~= nil and options.Draggable or true
    self.Resizable = options.Resizable ~= nil and options.Resizable or true
    
    -- Create main window frame
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name
    self.Instance.Position = self.Position
    self.Instance.Size = self.Size
    self.Instance.AnchorPoint = self.AnchorPoint
    self.Instance.BackgroundColor3 = self.Theme.WindowBackground
    self.Instance.BorderSizePixel = 0
    self.Instance.ZIndex = 1
    
    -- Corner radius
    self.Corner = Instance.new("UICorner")
    self.Corner.CornerRadius = UDim.new(0, 6)
    self.Corner.Parent = self.Instance
    
    -- Stroke/Border
    self.Stroke = Instance.new("UIStroke")
    self.Stroke.Color = self.Theme.WindowStroke
    self.Stroke.Thickness = 2
    self.Stroke.Parent = self.Instance
    
    -- Gradient effect
    self.Gradient = Instance.new("UIGradient")
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.WindowGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.WindowGradientEnd)
    })
    self.Gradient.Rotation = 45
    self.Gradient.Parent = self.Instance
    
    -- Glow effect
    self.Glow = Instance.new("ImageLabel")
    self.Glow.Name = "Glow"
    self.Glow.BackgroundTransparency = 1
    self.Glow.Size = UDim2.new(1, 20, 1, 20)
    self.Glow.Position = UDim2.new(0, -10, 0, -10)
    self.Glow.Image = "rbxassetid://5028857084" -- Circular glow
    self.Glow.ImageColor3 = self.Theme.AccentColor
    self.Glow.ImageTransparency = 0.8
    self.Glow.ZIndex = 0
    self.Glow.Parent = self.Instance
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = self.Theme.TitleBarBackground
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.ZIndex = 2
    self.TitleBar.Parent = self.Instance
    
    -- Title bar corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = self.TitleBar
    
    -- Make only top corners rounded
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Name = "CornerFix"
    titleCornerFix.Size = UDim2.new(1, 0, 0.5, 0)
    titleCornerFix.Position = UDim2.new(0, 0, 0.5, 0)
    titleCornerFix.BackgroundColor3 = self.Theme.TitleBarBackground
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.ZIndex = 2
    titleCornerFix.Parent = self.TitleBar
    
    -- Title bar gradient
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.TitleBarGradientStart),
        ColorSequenceKeypoint.new(1, self.Theme.TitleBarGradientEnd)
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = self.TitleBar
    
    -- Title text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "Title"
    self.TitleText.Text = self.Title
    self.TitleText.Size = UDim2.new(1, -10, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Font = self.Theme.Font
    self.TitleText.TextColor3 = self.Theme.TitleText
    self.TitleText.TextSize = self.Theme.TitleTextSize
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.ZIndex = 3
    self.TitleText.Parent = self.TitleBar
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Text = "×"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Font = self.Theme.Font
    self.CloseButton.TextColor3 = self.Theme.CloseButtonColor
    self.CloseButton.TextSize = 24
    self.CloseButton.ZIndex = 3
    self.CloseButton.Parent = self.TitleBar
    
    -- Container for content
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(1, -20, 1, -40)
    self.Container.Position = UDim2.new(0, 10, 0, 35)
    self.Container.BackgroundTransparency = 1
    self.Container.ZIndex = 2
    self.Container.Parent = self.Instance
    
    -- Setup scrolling container
    self.ScrollingContainer = Instance.new("ScrollingFrame")
    self.ScrollingContainer.Name = "ScrollingContainer"
    self.ScrollingContainer.Size = UDim2.new(1, 0, 1, 0)
    self.ScrollingContainer.BackgroundTransparency = 1
    self.ScrollingContainer.BorderSizePixel = 0
    self.ScrollingContainer.ScrollBarThickness = 4
    self.ScrollingContainer.ScrollBarImageColor3 = self.Theme.AccentColor
    self.ScrollingContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    self.ScrollingContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ScrollingContainer.ZIndex = 2
    self.ScrollingContainer.Parent = self.Container
    
    -- Layout for elements in the scrolling container
    self.Layout = Instance.new("UIListLayout")
    self.Layout.Padding = UDim.new(0, 8)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Parent = self.ScrollingContainer
    
    -- Resize handle (bottom right corner)
    if self.Resizable then
        self.ResizeHandle = Instance.new("TextButton")
        self.ResizeHandle.Name = "ResizeHandle"
        self.ResizeHandle.Text = ""
        self.ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
        self.ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
        self.ResizeHandle.BackgroundTransparency = 1
        self.ResizeHandle.ZIndex = 5
        self.ResizeHandle.Parent = self.Instance
        
        -- Resize handle icon
        local resizeIcon = Instance.new("ImageLabel")
        resizeIcon.Name = "Icon"
        resizeIcon.Size = UDim2.new(1, 0, 1, 0)
        resizeIcon.BackgroundTransparency = 1
        resizeIcon.Image = "rbxassetid://7733715400" -- Resize icon
        resizeIcon.ImageColor3 = self.Theme.AccentColor
        resizeIcon.ImageTransparency = 0.5
        resizeIcon.ZIndex = 5
        resizeIcon.Parent = self.ResizeHandle
    end
    
    -- Connect events
    self:_connectEvents()
    
    -- Set parent and animate entrance
    if self.Parent then
        self.Instance.Parent = self.Parent
        self:AnimateEntrance()
    end
    
    return self
end

function Window:_connectEvents()
    -- Close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Dragging
    if self.Draggable then
        local dragging = false
        local dragInput
        local dragStart
        local startPos
        
        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.Instance.Position
                
                -- Highlight titlebar while dragging
                TweenService:Create(self.TitleBar, TweenInfo.new(0.2), {
                    BackgroundColor3 = self.Theme.TitleBarBackgroundActive
                }):Play()
                
                -- Pulse effect on glow
                TweenService:Create(self.Glow, TweenInfo.new(0.3), {
                    ImageTransparency = 0.6
                }):Play()
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        
                        -- Reset titlebar color
                        TweenService:Create(self.TitleBar, TweenInfo.new(0.2), {
                            BackgroundColor3 = self.Theme.TitleBarBackground
                        }):Play()
                        
                        -- Reset glow
                        TweenService:Create(self.Glow, TweenInfo.new(0.3), {
                            ImageTransparency = 0.8
                        }):Play()
                    end
                end)
            end
        end)
        
        self.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                self.Instance.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    
    -- Resizing
    if self.Resizable and self.ResizeHandle then
        local resizing = false
        local resizeInput
        local resizeStart
        local startSize
        
        self.ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = input.Position
                startSize = self.Instance.Size
                
                -- Highlight resize handle during resize
                TweenService:Create(self.ResizeHandle.Icon, TweenInfo.new(0.2), {
                    ImageTransparency = 0
                }):Play()
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        resizing = false
                        
                        -- Reset resize handle
                        TweenService:Create(self.ResizeHandle.Icon, TweenInfo.new(0.2), {
                            ImageTransparency = 0.5
                        }):Play()
                    end
                end)
            end
        end)
        
        self.ResizeHandle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                resizeInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == resizeInput and resizing then
                local delta = input.Position - resizeStart
                local newWidth = startSize.X.Offset + delta.X
                local newHeight = startSize.Y.Offset + delta.Y
                
                -- Apply min size constraint
                newWidth = math.max(newWidth, self.MinSize.X)
                newHeight = math.max(newHeight, self.MinSize.Y)
                
                -- Apply max size constraint if specified
                if self.MaxSize then
                    newWidth = math.min(newWidth, self.MaxSize.X)
                    newHeight = math.min(newHeight, self.MaxSize.Y)
                end
                
                -- Apply new size
                self.Instance.Size = UDim2.new(
                    startSize.X.Scale,
                    newWidth,
                    startSize.Y.Scale,
                    newHeight
                )
            end
        end)
    end
end

function Window:AnimateEntrance()
    -- Initial state
    self.Instance.Size = UDim2.new(0, 0, 0, 0)
    self.Instance.BackgroundTransparency = 1
    self.TitleBar.BackgroundTransparency = 1
    self.TitleText.TextTransparency = 1
    self.CloseButton.TextTransparency = 1
    self.Stroke.Transparency = 1
    
    -- Animate entrance
    TweenService:Create(self.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = self.Size,
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(self.TitleBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.1), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(self.TitleText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(self.CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(self.Stroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3), {
        Transparency = 0
    }):Play()
    
    -- Glow effect
    TweenService:Create(self.Glow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4), {
        ImageTransparency = 0.8
    }):Play()
end

function Window:Close()
    -- Animate exit
    local closeTween = TweenService:Create(self.Instance, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    
    closeTween.Completed:Connect(function()
        self:Destroy()
    end)
    
    -- Fade out title and close button
    TweenService:Create(self.TitleText, TweenInfo.new(0.2), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(self.CloseButton, TweenInfo.new(0.2), {
        TextTransparency = 1
    }):Play()
    
    -- Fade out stroke
    TweenService:Create(self.Stroke, TweenInfo.new(0.2), {
        Transparency = 1
    }):Play()
    
    -- Fade out glow
    TweenService:Create(self.Glow, TweenInfo.new(0.2), {
        ImageTransparency = 1
    }):Play()
    
    closeTween:Play()
end

function Window:AddElement(element)
    if typeof(element) == "table" and element.Instance then
        element.Instance.Parent = self.ScrollingContainer
    elseif typeof(element) == "Instance" then
        element.Parent = self.ScrollingContainer
    end
    return element
end

function Window:CreateButton(options)
    local Button = require(script.Parent.Parent.Components.Button)
    options = options or {}
    options.Parent = self.ScrollingContainer
    options.Theme = self.Theme
    options.AnchorPoint = Vector2.new(0.5, 0)
    options.Position = UDim2.new(0.5, 0, 0, 0)
    
    return Button.new(options)
end

function Window:CreateTextInput(options)
    local TextInput = require(script.Parent.Parent.Components.TextInput)
    options = options or {}
    options.Parent = self.ScrollingContainer
    options.Theme = self.Theme
    options.AnchorPoint = Vector2.new(0.5, 0)
    options.Position = UDim2.new(0.5, 0, 0, 0)
    
    return TextInput.new(options)
end

function Window:CreateFrame(options)
    local Frame = require(script.Parent.Parent.Components.Frame)
    options = options or {}
    options.Parent = self.ScrollingContainer
    options.Theme = self.Theme
    options.AnchorPoint = Vector2.new(0.5, 0)
    options.Position = UDim2.new(0.5, 0, 0, 0)
    
    return Frame.new(options)
end

function Window:SetTitle(title)
    self.Title = title
    self.TitleText.Text = title
end

function Window:SetTheme(theme)
    self.Theme = theme
    
    self.Instance.BackgroundColor3 = theme.WindowBackground
    self.TitleBar.BackgroundColor3 = theme.TitleBarBackground
    self.TitleText.Font = theme.Font
    self.TitleText.TextColor3 = theme.TitleText
    self.TitleText.TextSize = theme.TitleTextSize
    self.CloseButton.Font = theme.Font
    self.CloseButton.TextColor3 = theme.CloseButtonColor
    self.Glow.ImageColor3 = theme.AccentColor
    self.Stroke.Color = theme.WindowStroke
    self.ScrollingContainer.ScrollBarImageColor3 = theme.AccentColor
    
    -- Update gradients
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.WindowGradientStart),
        ColorSequenceKeypoint.new(1, theme.WindowGradientEnd)
    })
    
    local titleGradient = self.TitleBar:FindFirstChildOfClass("UIGradient")
    if titleGradient then
        titleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.TitleBarGradientStart),
            ColorSequenceKeypoint.new(1, theme.TitleBarGradientEnd)
        })
    end
    
    -- Update resize handle if exists
    if self.ResizeHandle and self.ResizeHandle:FindFirstChild("Icon") then
        self.ResizeHandle.Icon.ImageColor3 = theme.AccentColor
    end
    
    -- Update title bar corner fix
    local cornerFix = self.TitleBar:FindFirstChild("CornerFix")
    if cornerFix then
        cornerFix.BackgroundColor3 = theme.TitleBarBackground
    end
end

function Window:Destroy()
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
    setmetatable(self, nil)
end

return Window
