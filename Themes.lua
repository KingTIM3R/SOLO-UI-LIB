--[[
    Themes for SoloLevelingUI
    Provides various color schemes inspired by Solo Leveling
]]

local Themes = {}

-- Font selections
local Fonts = {
    GothamBold = Enum.Font.GothamBold,
    GothamMedium = Enum.Font.GothamMedium,
    Gotham = Enum.Font.Gotham,
    Ubuntu = Enum.Font.Ubuntu,
    SciFi = Enum.Font.SciFi,
    SourceSansBold = Enum.Font.SourceSansBold,
    SourceSans = Enum.Font.SourceSans,
    Oswald = Enum.Font.Oswald,
    RobotoMono = Enum.Font.RobotoMono,
    SpecialElite = Enum.Font.SpecialElite
}

-- Default color scheme (inspired by Solo Leveling)
Themes.Default = {
    -- Font settings
    Font = Fonts.GothamBold,
    TitleTextSize = 18,
    ButtonTextSize = 16,
    BodyTextSize = 14,
    InputTextSize = 16,
    
    -- Colors: Primary UI elements
    AccentColor = Color3.fromRGB(64, 157, 254),  -- Blue accent (Solo Leveling)
    WindowBackground = Color3.fromRGB(25, 30, 40),
    WindowStroke = Color3.fromRGB(40, 100, 180),
    WindowGradientStart = Color3.fromRGB(30, 35, 45),
    WindowGradientEnd = Color3.fromRGB(20, 25, 35),
    
    -- Title bar
    TitleBarBackground = Color3.fromRGB(18, 22, 30),
    TitleBarBackgroundActive = Color3.fromRGB(30, 60, 100),
    TitleBarGradientStart = Color3.fromRGB(30, 60, 100),
    TitleBarGradientEnd = Color3.fromRGB(20, 30, 50),
    TitleText = Color3.fromRGB(255, 255, 255),
    CloseButtonColor = Color3.fromRGB(255, 255, 255),
    
    -- Buttons
    ButtonBackground = Color3.fromRGB(30, 35, 50),
    ButtonBackgroundHover = Color3.fromRGB(40, 60, 90),
    ButtonText = Color3.fromRGB(255, 255, 255),
    ButtonStroke = Color3.fromRGB(40, 100, 180),
    ButtonGradientStart = Color3.fromRGB(35, 40, 55),
    ButtonGradientEnd = Color3.fromRGB(25, 30, 45),
    
    -- Frames
    FrameBackground = Color3.fromRGB(20, 25, 35),
    FrameStroke = Color3.fromRGB(40, 100, 180),
    FrameGradientStart = Color3.fromRGB(25, 30, 40),
    FrameGradientEnd = Color3.fromRGB(15, 20, 30),
    
    -- Input fields
    InputBackground = Color3.fromRGB(15, 20, 30),
    InputStroke = Color3.fromRGB(40, 100, 180),
    InputText = Color3.fromRGB(255, 255, 255),
    InputPlaceholder = Color3.fromRGB(150, 160, 180),
    InputGradientStart = Color3.fromRGB(20, 25, 35),
    InputGradientEnd = Color3.fromRGB(15, 20, 30),
    
    -- Notifications
    NotificationBackground = Color3.fromRGB(20, 25, 35),
    NotificationTitle = Color3.fromRGB(255, 255, 255),
    NotificationText = Color3.fromRGB(200, 200, 220),
    NotificationGradientStart = Color3.fromRGB(25, 30, 45),
    NotificationGradientEnd = Color3.fromRGB(15, 20, 35),
}

-- Dark theme (Darker variation of Solo Leveling theme)
Themes.Dark = {
    -- Font settings
    Font = Fonts.GothamBold,
    TitleTextSize = 18,
    ButtonTextSize = 16,
    BodyTextSize = 14,
    InputTextSize = 16,
    
    -- Colors: Primary UI elements
    AccentColor = Color3.fromRGB(30, 110, 200),
    WindowBackground = Color3.fromRGB(15, 18, 25),
    WindowStroke = Color3.fromRGB(30, 80, 150),
    WindowGradientStart = Color3.fromRGB(20, 23, 30),
    WindowGradientEnd = Color3.fromRGB(10, 13, 20),
    
    -- Title bar
    TitleBarBackground = Color3.fromRGB(12, 15, 20),
    TitleBarBackgroundActive = Color3.fromRGB(20, 40, 70),
    TitleBarGradientStart = Color3.fromRGB(20, 40, 80),
    TitleBarGradientEnd = Color3.fromRGB(10, 20, 40),
    TitleText = Color3.fromRGB(220, 230, 255),
    CloseButtonColor = Color3.fromRGB(220, 230, 255),
    
    -- Buttons
    ButtonBackground = Color3.fromRGB(20, 25, 35),
    ButtonBackgroundHover = Color3.fromRGB(30, 50, 80),
    ButtonText = Color3.fromRGB(220, 230, 255),
    ButtonStroke = Color3.fromRGB(30, 80, 150),
    ButtonGradientStart = Color3.fromRGB(25, 30, 40),
    ButtonGradientEnd = Color3.fromRGB(15, 20, 30),
    
    -- Frames
    FrameBackground = Color3.fromRGB(12, 15, 22),
    FrameStroke = Color3.fromRGB(30, 80, 150),
    FrameGradientStart = Color3.fromRGB(17, 20, 27),
    FrameGradientEnd = Color3.fromRGB(10, 13, 20),
    
    -- Input fields
    InputBackground = Color3.fromRGB(10, 13, 20),
    InputStroke = Color3.fromRGB(30, 80, 150),
    InputText = Color3.fromRGB(220, 230, 255),
    InputPlaceholder = Color3.fromRGB(120, 130, 150),
    InputGradientStart = Color3.fromRGB(15, 18, 25),
    InputGradientEnd = Color3.fromRGB(10, 13, 20),
    
    -- Notifications
    NotificationBackground = Color3.fromRGB(12, 15, 22),
    NotificationTitle = Color3.fromRGB(220, 230, 255),
    NotificationText = Color3.fromRGB(180, 190, 210),
    NotificationGradientStart = Color3.fromRGB(17, 20, 30),
    NotificationGradientEnd = Color3.fromRGB(10, 13, 22),
}

-- Shadow Monarch theme (Inspired by Shadow Monarch in Solo Leveling)
Themes.ShadowMonarch = {
    -- Font settings
    Font = Fonts.GothamBold,
    TitleTextSize = 18,
    ButtonTextSize = 16,
    BodyTextSize = 14,
    InputTextSize = 16,
    
    -- Colors: Primary UI elements
    AccentColor = Color3.fromRGB(120, 0, 255),  -- Purple accent
    WindowBackground = Color3.fromRGB(20, 15, 30),
    WindowStroke = Color3.fromRGB(80, 0, 150),
    WindowGradientStart = Color3.fromRGB(25, 20, 35),
    WindowGradientEnd = Color3.fromRGB(15, 10, 25),
    
    -- Title bar
    TitleBarBackground = Color3.fromRGB(15, 10, 25),
    TitleBarBackgroundActive = Color3.fromRGB(60, 0, 100),
    TitleBarGradientStart = Color3.fromRGB(60, 0, 110),
    TitleBarGradientEnd = Color3.fromRGB(30, 0, 60),
    TitleText = Color3.fromRGB(230, 210, 255),
    CloseButtonColor = Color3.fromRGB(230, 210, 255),
    
    -- Buttons
    ButtonBackground = Color3.fromRGB(30, 20, 40),
    ButtonBackgroundHover = Color3.fromRGB(60, 30, 90),
    ButtonText = Color3.fromRGB(230, 210, 255),
    ButtonStroke = Color3.fromRGB(80, 0, 150),
    ButtonGradientStart = Color3.fromRGB(35, 25, 45),
    ButtonGradientEnd = Color3.fromRGB(25, 15, 35),
    
    -- Frames
    FrameBackground = Color3.fromRGB(15, 10, 25),
    FrameStroke = Color3.fromRGB(80, 0, 150),
    FrameGradientStart = Color3.fromRGB(20, 15, 30),
    FrameGradientEnd = Color3.fromRGB(10, 5, 20),
    
    -- Input fields
    InputBackground = Color3.fromRGB(10, 5, 20),
    InputStroke = Color3.fromRGB(80, 0, 150),
    InputText = Color3.fromRGB(230, 210, 255),
    InputPlaceholder = Color3.fromRGB(140, 120, 160),
    InputGradientStart = Color3.fromRGB(15, 10, 25),
    InputGradientEnd = Color3.fromRGB(10, 5, 20),
    
    -- Notifications
    NotificationBackground = Color3.fromRGB(15, 10, 25),
    NotificationTitle = Color3.fromRGB(230, 210, 255),
    NotificationText = Color3.fromRGB(190, 170, 210),
    NotificationGradientStart = Color3.fromRGB(20, 15, 35),
    NotificationGradientEnd = Color3.fromRGB(10, 5, 25),
}

-- Function to create a custom theme based on an accent color
function Themes.CreateCustomTheme(accentColor, fontSelection, darkMode)
    local font = fontSelection or Fonts.GothamBold
    local isDark = darkMode ~= nil and darkMode or true
    
    local baseBackground = isDark 
        and Color3.fromRGB(20, 25, 35) 
        or Color3.fromRGB(240, 240, 245)
    
    local textColor = isDark 
        and Color3.fromRGB(255, 255, 255) 
        or Color3.fromRGB(10, 10, 20)
    
    -- Derive complementary colors
    local h, s, v = accentColor:ToHSV()
    
    -- Create a darker shade of accent
    local darkerAccent = Color3.fromHSV(h, math.max(0, s - 0.1), math.max(0, v - 0.3))
    
    -- Create a lighter shade of accent
    local lighterAccent = Color3.fromHSV(h, math.max(0, s - 0.2), math.min(1, v + 0.2))
    
    return {
        -- Font settings
        Font = font,
        TitleTextSize = 18,
        ButtonTextSize = 16,
        BodyTextSize = 14,
        InputTextSize = 16,
        
        -- Colors: Primary UI elements
        AccentColor = accentColor,
        WindowBackground = baseBackground,
        WindowStroke = accentColor,
        WindowGradientStart = isDark 
            and Color3.fromRGB(25, 30, 40) 
            or Color3.fromRGB(230, 230, 240),
        WindowGradientEnd = isDark 
            and Color3.fromRGB(15, 20, 30) 
            or Color3.fromRGB(210, 210, 225),
        
        -- Title bar
        TitleBarBackground = isDark 
            and Color3.fromRGB(15, 20, 30) 
            or Color3.fromRGB(220, 220, 230),
        TitleBarBackgroundActive = darkerAccent,
        TitleBarGradientStart = accentColor,
        TitleBarGradientEnd = darkerAccent,
        TitleText = textColor,
        CloseButtonColor = textColor,
        
        -- Buttons
        ButtonBackground = isDark 
            and Color3.fromRGB(25, 30, 45) 
            or Color3.fromRGB(230, 230, 240),
        ButtonBackgroundHover = isDark 
            and Color3.fromRGB(40, 50, 70) 
            or lighterAccent,
        ButtonText = textColor,
        ButtonStroke = accentColor,
        ButtonGradientStart = isDark 
            and Color3.fromRGB(30, 35, 50) 
            or Color3.fromRGB(235, 235, 245),
        ButtonGradientEnd = isDark 
            and Color3.fromRGB(20, 25, 40) 
            or Color3.fromRGB(225, 225, 235),
        
        -- Frames
        FrameBackground = isDark 
            and Color3.fromRGB(15, 20, 30) 
            or Color3.fromRGB(225, 225, 235),
        FrameStroke = accentColor,
        FrameGradientStart = isDark 
            and Color3.fromRGB(20, 25, 35) 
            or Color3.fromRGB(230, 230, 240),
        FrameGradientEnd = isDark 
            and Color3.fromRGB(10, 15, 25) 
            or Color3.fromRGB(215, 215, 225),
        
        -- Input fields
        InputBackground = isDark 
            and Color3.fromRGB(12, 17, 27) 
            or Color3.fromRGB(220, 220, 230),
        InputStroke = accentColor,
        InputText = textColor,
        InputPlaceholder = isDark 
            and Color3.fromRGB(140, 150, 170) 
            or Color3.fromRGB(120, 120, 130),
        InputGradientStart = isDark 
            and Color3.fromRGB(17, 22, 32) 
            or Color3.fromRGB(225, 225, 235),
        InputGradientEnd = isDark 
            and Color3.fromRGB(12, 17, 27) 
            or Color3.fromRGB(215, 215, 225),
        
        -- Notifications
        NotificationBackground = isDark 
            and Color3.fromRGB(15, 20, 30) 
            or Color3.fromRGB(225, 225, 235),
        NotificationTitle = textColor,
        NotificationText = isDark 
            and Color3.fromRGB(200, 200, 210) 
            or Color3.fromRGB(40, 40, 50),
        NotificationGradientStart = isDark 
            and Color3.fromRGB(20, 25, 35) 
            or Color3.fromRGB(230, 230, 240),
        NotificationGradientEnd = isDark 
            and Color3.fromRGB(10, 15, 25) 
            or Color3.fromRGB(215, 215, 225),
    }
end

return Themes
