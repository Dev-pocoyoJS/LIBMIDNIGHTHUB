local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local UIS = game:GetService("UserInputService")

local themes = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background  = Color3.fromRGB(36, 37, 43),
    Header      = Color3.fromRGB(28, 29, 34),
    TextColor   = Color3.fromRGB(255, 255, 255),
    ElementColor= Color3.fromRGB(32, 32, 38)
}

local themeStyles = {
    DarkTheme  = { SchemeColor=Color3.fromRGB(64,64,64),     Background=Color3.fromRGB(0,0,0),       Header=Color3.fromRGB(0,0,0),       TextColor=Color3.fromRGB(255,255,255), ElementColor=Color3.fromRGB(20,20,20)   },
    LightTheme = { SchemeColor=Color3.fromRGB(150,150,150),  Background=Color3.fromRGB(255,255,255), Header=Color3.fromRGB(200,200,200), TextColor=Color3.fromRGB(0,0,0),       ElementColor=Color3.fromRGB(224,224,224)},
    BloodTheme = { SchemeColor=Color3.fromRGB(227,27,27),    Background=Color3.fromRGB(10,10,10),    Header=Color3.fromRGB(5,5,5),       TextColor=Color3.fromRGB(255,255,255), ElementColor=Color3.fromRGB(20,20,20)   },
    GrapeTheme = { SchemeColor=Color3.fromRGB(166,71,214),   Background=Color3.fromRGB(64,50,71),    Header=Color3.fromRGB(36,28,41),    TextColor=Color3.fromRGB(255,255,255), ElementColor=Color3.fromRGB(74,58,84)   },
    Ocean      = { SchemeColor=Color3.fromRGB(86,76,251),    Background=Color3.fromRGB(26,32,58),    Header=Color3.fromRGB(38,45,71),    TextColor=Color3.fromRGB(200,200,200), ElementColor=Color3.fromRGB(38,45,71)   },
    Midnight   = { SchemeColor=Color3.fromRGB(26,189,158),   Background=Color3.fromRGB(44,62,82),    Header=Color3.fromRGB(57,81,105),   TextColor=Color3.fromRGB(255,255,255), ElementColor=Color3.fromRGB(52,74,95)   },
    Sentinel   = { SchemeColor=Color3.fromRGB(230,35,69),    Background=Color3.fromRGB(32,32,32),    Header=Color3.fromRGB(24,24,24),    TextColor=Color3.fromRGB(119,209,138), ElementColor=Color3.fromRGB(24,24,24)   },
    Synapse    = { SchemeColor=Color3.fromRGB(46,48,43),     Background=Color3.fromRGB(13,15,12),    Header=Color3.fromRGB(36,38,35),    TextColor=Color3.fromRGB(152,99,53),   ElementColor=Color3.fromRGB(24,24,24)   },
    Serpent    = { SchemeColor=Color3.fromRGB(0,166,58),     Background=Color3.fromRGB(31,41,43),    Header=Color3.fromRGB(22,29,31),    TextColor=Color3.fromRGB(255,255,255), ElementColor=Color3.fromRGB(22,29,31)   },
}

local LibName = tostring(math.random(1,100))..tostring(math.random(1,50))..tostring(math.random(1,100))

function Kavo:ToggleUI()
    local sg = game.CoreGui:FindFirstChild(LibName)
    if sg then sg.Enabled = not sg.Enabled end
end

function Kavo:ChangeColor(prope, color, themeList)
    if themeList and themeList[prope] ~= nil then
        themeList[prope] = color
    end
end

-- ─── Drag helper ────────────────────────────────────────────────────────────
local function makeDraggable(handle, target)
    target = target or handle
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            mousePos  = inp.Position
            framePos  = target.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - mousePos
            target.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end
-- ────────────────────────────────────────────────────────────────────────────

function Kavo.CreateLib(kavName, themeArg)
    -- resolve theme
    local themeList
    if type(themeArg) == "string" and themeStyles[themeArg] then
        themeList = themeStyles[themeArg]
    elseif type(themeArg) == "table" then
        themeList = themeArg
        themeList.SchemeColor  = themeList.SchemeColor  or Color3.fromRGB(74,99,135)
        themeList.Background   = themeList.Background   or Color3.fromRGB(36,37,43)
        themeList.Header       = themeList.Header       or Color3.fromRGB(28,29,34)
        themeList.TextColor    = themeList.TextColor    or Color3.fromRGB(255,255,255)
        themeList.ElementColor = themeList.ElementColor or Color3.fromRGB(32,32,38)
    else
        themeList = themes
    end

    kavName = kavName or "Library"

    -- remove old gui with same name
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then v:Destroy() end
    end

    -- ── ScreenGui ──────────────────────────────────────────────────────────
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name          = LibName
    ScreenGui.Parent        = game.CoreGui
    ScreenGui.ZIndexBehavior= Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn  = false

    -- ── Main frame ─────────────────────────────────────────────────────────
    local Main = Instance.new("Frame")
    Main.Name               = "Main"
    Main.Parent             = ScreenGui
    Main.BackgroundColor3   = themeList.Background
    Main.ClipsDescendants   = true
    Main.Position           = UDim2.new(0.5, -262, 0.5, -159)
    Main.Size               = UDim2.new(0, 525, 0, 318)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    -- ── Header (drag handle) ───────────────────────────────────────────────
    local MainHeader = Instance.new("Frame")
    MainHeader.Name           = "MainHeader"
    MainHeader.Parent         = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size           = UDim2.new(1, 0, 0, 32)
    MainHeader.ZIndex         = 2
    Instance.new("UICorner", MainHeader).CornerRadius = UDim.new(0, 6)

    -- cover bottom-radius of header so it looks flat at the bottom
    local headerFlat = Instance.new("Frame")
    headerFlat.Parent           = MainHeader
    headerFlat.BackgroundColor3 = themeList.Header
    headerFlat.BorderSizePixel  = 0
    headerFlat.Position         = UDim2.new(0, 0, 0.6, 0)
    headerFlat.Size             = UDim2.new(1, 0, 0.4, 0)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent               = MainHeader
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position             = UDim2.new(0.018, 0, 0, 0)
    titleLabel.Size                 = UDim2.new(0.85, 0, 1, 0)
    titleLabel.Font                 = Enum.Font.GothamSemibold
    titleLabel.Text                 = kavName
    titleLabel.RichText             = true
    titleLabel.TextColor3           = themeList.TextColor
    titleLabel.TextSize             = 15
    titleLabel.TextXAlignment       = Enum.TextXAlignment.Left
    titleLabel.ZIndex               = 3

    -- ── Content area ───────────────────────────────────────────────────────
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name                 = "Content"
    ContentFrame.Parent               = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel      = 0
    ContentFrame.Position             = UDim2.new(0, 0, 0, 32)
    ContentFrame.Size                 = UDim2.new(1, 0, 1, -32)
    ContentFrame.ScrollBarThickness   = 4
    ContentFrame.ScrollBarImageColor3 = themeList.SchemeColor
    ContentFrame.CanvasSize           = UDim2.new(0, 0, 0, 0)

    local contentList = Instance.new("UIListLayout")
    contentList.Parent    = ContentFrame
    contentList.Padding   = UDim.new(0, 6)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", ContentFrame).PaddingTop = UDim.new(0, 8)

    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 16)
    end)

    -- ── DRAG on header ─────────────────────────────────────────────────────
    makeDraggable(MainHeader, Main)

    -- ── Theme coroutine ────────────────────────────────────────────────────
    coroutine.wrap(function()
        while task.wait() do
            Main.BackgroundColor3       = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            headerFlat.BackgroundColor3 = themeList.Header
            titleLabel.TextColor3       = themeList.TextColor
            ContentFrame.ScrollBarImageColor3 = themeList.SchemeColor
        end
    end)()

    -- ── Logo toggle button ─────────────────────────────────────────────────
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name             = "LogoToggle"
    toggleButton.Parent           = ScreenGui
    toggleButton.BackgroundColor3 = themeList.Header
    toggleButton.Size             = UDim2.new(0, 48, 0, 48)
    toggleButton.Position         = UDim2.new(0, 14, 0.5, -24)
    toggleButton.ZIndex           = 10
    toggleButton.Image            = "rbxassetid://84427155383225"
    toggleButton.ScaleType        = Enum.ScaleType.Fit
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color     = themeList.SchemeColor
    btnStroke.Thickness = 2
    btnStroke.Parent    = toggleButton

    makeDraggable(toggleButton, toggleButton)

    local uiVisible = true

    toggleButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        if uiVisible then
            Main.Visible = true
            tween:Create(Main, tweeninfo(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 525, 0, 318)
            }):Play()
        else
            tween:Create(Main, tweeninfo(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.delay(0.21, function() Main.Visible = false end)
        end
        tween:Create(toggleButton, tweeninfo(0.15), {
            ImageTransparency = uiVisible and 0 or 0.4
        }):Play()
    end)

    toggleButton.MouseEnter:Connect(function()
        tween:Create(toggleButton, tweeninfo(0.12), { Size = UDim2.new(0,54,0,54) }):Play()
    end)
    toggleButton.MouseLeave:Connect(function()
        tween:Create(toggleButton, tweeninfo(0.12), { Size = UDim2.new(0,48,0,48) }):Play()
    end)

    coroutine.wrap(function()
        while task.wait() do
            btnStroke.Color             = themeList.SchemeColor
            toggleButton.BackgroundColor3 = themeList.Header
        end
    end)()

    -- ── Public API ─────────────────────────────────────────────────────────
    local Window = {}

    function Window:ChangeColor(prope, color)
        if themeList[prope] ~= nil then themeList[prope] = color end
    end

    function Window:GetContentFrame()
        return ContentFrame
    end

    return Window
end

return Kavo
