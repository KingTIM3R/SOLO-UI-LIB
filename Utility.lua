--[[
    Utility Functions
    Helper functions for the UI library
]]

local TweenService = game:GetService("TweenService")

local Utility = {}

-- Solo Leveling-style ripple effect
function Utility.PlaySoloLevelingEffect(button)
    -- Create a ripple effect
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    
    -- Add corner radius to ripple
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- Make it circular
    corner.Parent = ripple
    
    ripple.Parent = button
    
    -- Animate ripple effect
    local buttonSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
    TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(0, buttonSize, 0, buttonSize),
        BackgroundTransparency = 1
    }):Play()
    
    -- Create glow flash
    local glow = Instance.new("ImageLabel")
    glow.Name = "ClickGlow"
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.Image = "rbxassetid://5028857084" -- Circular glow
    glow.ImageColor3 = Color3.fromRGB(64, 157, 254) -- Blue glow
    glow.ImageTransparency = 1
    glow.ZIndex = button.ZIndex - 1
    glow.Parent = button
    
    -- Animate glow flash
    local glowTween = TweenService:Create(glow, TweenInfo.new(0.3), {
        ImageTransparency = 0.7
    })
    
    local glowTweenOut = TweenService:Create(glow, TweenInfo.new(0.3), {
        ImageTransparency = 1
    })
    
    glowTween:Play()
    glowTween.Completed:Connect(function()
        glowTweenOut:Play()
        glowTweenOut.Completed:Connect(function()
            glow:Destroy()
        end)
    end)
    
    -- Clean up ripple
    spawn(function()
        wait(0.5)
        ripple:Destroy()
    end)
end

-- Create a Solo Leveling style pop-in effect
function Utility.PopInEffect(guiObject, delay)
    delay = delay or 0
    
    -- Store original properties
    local originalSize = guiObject.Size
    local originalPosition = guiObject.Position
    local originalTransparency
    
    if guiObject:IsA("GuiObject") then
        originalTransparency = guiObject.BackgroundTransparency
        guiObject.BackgroundTransparency = 1
    elseif guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
        originalTransparency = guiObject.TextTransparency
        guiObject.TextTransparency = 1
    elseif guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
        originalTransparency = guiObject.ImageTransparency
        guiObject.ImageTransparency = 1
    end
    
    -- Set initial state
    guiObject.Size = UDim2.new(0, 0, 0, 0)
    guiObject.Position = UDim2.new(
        originalPosition.X.Scale + (originalSize.X.Scale / 2),
        originalPosition.X.Offset + (originalSize.X.Offset / 2),
        originalPosition.Y.Scale + (originalSize.Y.Scale / 2),
        originalPosition.Y.Offset + (originalSize.Y.Offset / 2)
    )
    guiObject.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Wait for delay
    spawn(function()
        wait(delay)
        
        -- Animate to original size
        local sizeTween = TweenService:Create(guiObject, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = originalPosition
        })
        
        -- Animate transparency
        local transparencyTween
        if guiObject:IsA("GuiObject") then
            transparencyTween = TweenService:Create(guiObject, TweenInfo.new(0.4), {
                BackgroundTransparency = originalTransparency
            })
        elseif guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
            transparencyTween = TweenService:Create(guiObject, TweenInfo.new(0.4), {
                TextTransparency = originalTransparency
            })
        elseif guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
            transparencyTween = TweenService:Create(guiObject, TweenInfo.new(0.4), {
                ImageTransparency = originalTransparency
            })
        end
        
        -- Play tweens
        sizeTween:Play()
        if transparencyTween then
            transparencyTween:Play()
        end
    end)
end

-- Create a Solo Leveling blue particles effect
function Utility.CreateBlueParticles(parent, count, duration)
    count = count or 10
    duration = duration or 2
    
    for i = 1, count do
        local particle = Instance.new("Frame")
        particle.Name = "BlueParticle"
        particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        particle.BorderSizePixel = 0
        particle.BackgroundColor3 = Color3.fromRGB(64, 157, 254) -- Blue color
        particle.BackgroundTransparency = 0.2
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.ZIndex = parent.ZIndex + 1
        
        -- Add corner radius
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0) -- Make it circular
        corner.Parent = particle
        
        -- Add glow
        local glow = Instance.new("UIGradient")
        glow.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 157, 254))
        })
        glow.Parent = particle
        
        particle.Parent = parent
        
        -- Animate the particle
        spawn(function()
            local startPosition = particle.Position
            local endPosition = UDim2.new(
                startPosition.X.Scale + (math.random() - 0.5) * 0.5,
                startPosition.X.Offset,
                startPosition.Y.Scale - math.random(0.3, 0.7),
                startPosition.Y.Offset
            )
            
            local fadeOutTime = duration * 0.7
            
            -- Move upward
            TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = endPosition,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            -- Fade out
            wait(fadeOutTime)
            TweenService:Create(particle, TweenInfo.new(duration - fadeOutTime), {
                BackgroundTransparency = 1
            }):Play()
            
            -- Cleanup
            wait(duration - fadeOutTime)
            particle:Destroy()
        end)
    end
end

-- Check if mobile device
function Utility.IsMobile()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Format number with commas
function Utility.FormatNumber(number)
    local formatted = tostring(number)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Format time (seconds to MM:SS format)
function Utility.FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

return Utility
