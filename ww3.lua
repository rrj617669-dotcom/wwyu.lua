-- Advanced Universal Auto Clicker (GitHub/DevForum Methods)
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup previous instances
if PlayerGui:FindFirstChild("UniversalClickerV3") then
    PlayerGui.UniversalClickerV3:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalClickerV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 -- Priority over game UI
ScreenGui.Parent = PlayerGui

-- Control Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 130)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Universal Clicker V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame

-- Target Button
local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0, 40, 0, 40)
TargetBtn.Position = UDim2.new(0.5, -20, 0.2, 0)
TargetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 80)
TargetBtn.BackgroundTransparency = 0.2
TargetBtn.Text = "🎯"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.TextSize = 18
TargetBtn.Active = true
TargetBtn.Draggable = true
TargetBtn.Parent = ScreenGui

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(1, 0)
TargetCorner.Parent = TargetBtn

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ToggleBtn.Text = "Start Clicker"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- Clicker Engine
local clicking = false

local function executeUniversalClick()
    local targetPos = TargetBtn.AbsolutePosition + (TargetBtn.AbsoluteSize / 2)
    local x = targetPos.X
    local y = targetPos.Y + 36 -- Offset compensation for topbar

    -- Method 1: Physical Mouse Simulation via VirtualInputManager
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)

    -- Method 2: Physical Touch Simulation (For Mobile / Touch Interfaces)
    pcall(function()
        VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.Begin, x, y)
        VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.End, x, y)
    end)

    -- Method 3: Direct UI Fires (Fallback)
    pcall(function()
        local objects = PlayerGui:GetGuiObjectsAtPosition(targetPos.X, targetPos.Y)
        for _, obj in ipairs(objects) do
            if obj:IsA("GuiButton") and obj ~= TargetBtn and obj ~= ToggleBtn then
                for _, connection in ipairs(getconnections(obj.MouseButton1Down)) do
                    connection:Fire()
                end
                for _, connection in ipairs(getconnections(obj.MouseButton1Click)) do
                    connection:Fire()
                end
                for _, connection in ipairs(getconnections(obj.Activated)) do
                    connection:Fire()
                end
            end
        end
    end)
end

local function clickLoop()
    while clicking do
        executeUniversalClick()
        task.wait(0.01) -- High-speed click interval
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    if clicking then
        ToggleBtn.Text = "Stop Clicker"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        task.spawn(clickLoop)
    else
        ToggleBtn.Text = "Start Clicker"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    end
end)
