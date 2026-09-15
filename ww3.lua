-- Roblox Universal Native Auto Clicker (GitHub Engine)
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup
if PlayerGui:FindFirstChild("NativeAutoClicker") then
    PlayerGui.NativeAutoClicker:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NativeAutoClicker"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = PlayerGui

-- Main Panel
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Universal Clicker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame

-- Target Frame (Transparent Area)
local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0, 45, 0, 45)
TargetBtn.Position = UDim2.new(0.5, -22, 0.22, 0)
TargetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
TargetBtn.BackgroundTransparency = 0.5
TargetBtn.Text = "🎯"
TargetBtn.TextSize = 20
TargetBtn.Active = true
TargetBtn.Draggable = true
TargetBtn.Parent = ScreenGui

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(1, 0)
TargetCorner.Parent = TargetBtn

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- Logic Engine
local clicking = false

local function performNativeClick()
    local targetPos = TargetBtn.AbsolutePosition + (TargetBtn.AbsoluteSize / 2)
    local vecPos = Vector2.new(targetPos.X, targetPos.Y + 36)

    -- Temporary disable target button interaction so click passes through to the game below
    TargetBtn.Active = false
    
    -- Method A: Core VirtualUser Click (Bypasses Roblox UI Blockers)
    pcall(function()
        VirtualUser:ClickButton1(vecPos)
    end)

    -- Method B: Executor Native mouse1click (If supported by your executor)
    if mouse1click then
        pcall(function()
            mouse1click(vecPos.X, vecPos.Y)
        end)
    end

    TargetBtn.Active = true
end

local function loop()
    while clicking do
        performNativeClick()
        task.wait(0.005) -- Fast response loop
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    if clicking then
        ToggleBtn.Text = "STOP"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
        task.spawn(loop)
    else
        ToggleBtn.Text = "START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    end
end)
