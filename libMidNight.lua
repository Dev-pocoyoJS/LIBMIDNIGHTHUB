-- MIDNIGHTHUB UI LIBRARY
-- Clean black UI | Drag enabled | Open/Close logo button

local MidnightHub = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ══════════════════════════════════════════
--              DRAG FUNCTION
-- ══════════════════════════════════════════
local function EnableDrag(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = inp.Position
            framePos = parent.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - mousePos
            parent.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ══════════════════════════════════════════
--              CREATE UI
-- ══════════════════════════════════════════
function MidnightHub:CreateLib()
    local LibName = "MidnightHub_" .. tostring(math.random(1000, 9999))

    -- Remove existing instance
    pcall(function()
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v.Name:find("MidnightHub") then v:Destroy() end
        end
    end)

    -- ── ScreenGui ──────────────────────────────
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibName
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999

    -- ── Wrapper (holds title + main together for drag) ─
    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "Wrapper"
    Wrapper.Parent = ScreenGui
    Wrapper.BackgroundTransparency = 1
    Wrapper.Position = UDim2.new(0.5, -215, 0.5, -170)
    Wrapper.Size = UDim2.new(0, 430, 0, 340)
    Wrapper.ClipsDescendants = false

    -- ── Title Label (acima da UI, estilo BananaHub) ────
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = Wrapper
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.Size = UDim2.new(1, 0, 0, 28)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "MIDNIGHTHUB"
    TitleLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
    TitleLabel.TextSize = 17
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.RichText = true

    -- Dash separator after name (like BananaHub - "Banana Cat Hub  -  Blox Fruit")
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "SubLabel"
    SubLabel.Parent = Wrapper
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(0, 0, 0, 0)
    SubLabel.Size = UDim2.new(1, -10, 0, 28)
    SubLabel.Font = Enum.Font.GothamBold
    SubLabel.Text = "MIDNIGHTHUB"
    SubLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
    SubLabel.TextSize = 17
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.RichText = true
    SubLabel.Visible = false  -- hidden, TitleLabel is used

    -- ── Main Frame ─────────────────────────────
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = Wrapper
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0, 0, 0, 30)
    Main.Size = UDim2.new(0, 430, 0, 300)
    Main.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = Main

    -- ── Header (drag area) ─────────────────────
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 34)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = Header

    -- Fill bottom corners of header
    local HeaderCoverBottom = Instance.new("Frame")
    HeaderCoverBottom.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    HeaderCoverBottom.BorderSizePixel = 0
    HeaderCoverBottom.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderCoverBottom.Size = UDim2.new(1, 0, 0.5, 0)
    HeaderCoverBottom.Parent = Header

    -- ── Close Button (inside header, right side) ─
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.ZIndex = 5
    CloseBtn.Image = "rbxassetid://3926305904"
    CloseBtn.ImageRectOffset = Vector2.new(284, 4)
    CloseBtn.ImageRectSize = Vector2.new(24, 24)
    CloseBtn.ImageColor3 = Color3.fromRGB(200, 0, 0)

    -- ── Content Area (empty black body) ───────────
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = Main
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 0, 0, 34)
    ContentArea.Size = UDim2.new(1, 0, 1, -34)
    ContentArea.BorderSizePixel = 0

    -- ── Open Button (floating logo button) ────────
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Name = "OpenBtn"
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    OpenBtn.BorderSizePixel = 0
    OpenBtn.Position = UDim2.new(0, 10, 0.5, -28)
    OpenBtn.Size = UDim2.new(0, 56, 0, 56)
    OpenBtn.ZIndex = 10
    OpenBtn.Image = "rbxassetid://84427155383225"
    OpenBtn.Visible = false  -- only shows when UI is hidden

    local OpenBtnCorner = Instance.new("UICorner")
    OpenBtnCorner.CornerRadius = UDim.new(0, 8)
    OpenBtnCorner.Parent = OpenBtn

    local OpenBtnStroke = Instance.new("UIStroke")
    OpenBtnStroke.Color = Color3.fromRGB(180, 0, 0)
    OpenBtnStroke.Thickness = 1.5
    OpenBtnStroke.Parent = OpenBtn

    -- Drag for OpenBtn
    EnableDrag(OpenBtn, OpenBtn)

    -- ══════════════════════════════════════════
    --   DRAG — header drags the whole Wrapper
    -- ══════════════════════════════════════════
    EnableDrag(Header, Wrapper)

    -- ══════════════════════════════════════════
    --   CLOSE / OPEN LOGIC
    -- ══════════════════════════════════════════
    local isOpen = true

    local function HideUI()
        isOpen = false
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 215, 0, 30 + 150)
        }):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        wait(0.22)
        Wrapper.Visible = false
        OpenBtn.Visible = true
        TweenService:Create(OpenBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end

    local function ShowUI()
        isOpen = true
        Wrapper.Visible = true
        OpenBtn.Visible = false
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0, 215, 0, 30 + 150)
        TitleLabel.TextTransparency = 1
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 430, 0, 300),
            Position = UDim2.new(0, 0, 0, 30)
        }):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    end

    CloseBtn.MouseButton1Click:Connect(HideUI)
    OpenBtn.MouseButton1Click:Connect(ShowUI)

    -- ══════════════════════════════════════════
    --   KEYBIND: RightShift to toggle
    -- ══════════════════════════════════════════
    UserInputService.InputBegan:Connect(function(inp, processed)
        if not processed and inp.KeyCode == Enum.KeyCode.RightShift then
            if isOpen then HideUI() else ShowUI() end
        end
    end)

    -- ══════════════════════════════════════════
    --   PUBLIC API
    -- ══════════════════════════════════════════
    local API = {}

    function API:Toggle()
        if isOpen then HideUI() else ShowUI() end
    end

    function API:GetContentFrame()
        return ContentArea
    end

    function API:SetSubtitle(text)
        -- Updates the text after the dash (like "MIDNIGHTHUB  -  Blox Fruit")
        TitleLabel.Text = "MIDNIGHTHUB  <font color='#ffffff'>-</font>  <font color='#aaaaaa'>" .. tostring(text) .. "</font>"
    end

    function API:Destroy()
        ScreenGui:Destroy()
    end

    return API
end

return MidnightHub
