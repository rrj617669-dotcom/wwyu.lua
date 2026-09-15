-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Target Position Variable
local TargetPosition = nil
local SelectingTarget = false

-- Remote Setup (From your provided images)
local MissileRemotes = Workspace:FindFirstChild("MissileAttackRemotes")
local LaunchRemote = MissileRemotes and MissileRemotes:FindFirstChild("MissileLaunchRequest")

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FastRocketLauncher"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 210)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner Radius
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

-- Title Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Header.Text = "🚀 Fast Multi-Rocket Launcher"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 15
Header.Font = Enum.Font.SourceSansBold
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- 1. TARGET BUTTON
local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0.9, 0, 0, 45)
TargetBtn.Position = UDim2.new(0.05, 0, 0, 55)
TargetBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TargetBtn.Text = "🎯 Select Target Location"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.SourceSansBold
TargetBtn.TextSize = 14
TargetBtn.Parent = MainFrame

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 6)
TargetCorner.Parent = TargetBtn

-- 2. LAUNCH ALL BUTTON
local LaunchAllBtn = Instance.new("TextButton")
LaunchAllBtn.Size = UDim2.new(0.9, 0, 0, 55)
LaunchAllBtn.Position = UDim2.new(0.05, 0, 0, 115)
LaunchAllBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
LaunchAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchAllBtn.Font = Enum.Font.SourceSansBold
LaunchAllBtn.TextSize = 16
LaunchAllBtn.Parent = MainFrame

local LaunchCorner = Instance.new("UICorner")
LaunchCorner.CornerRadius = UDim.new(0, 6)
LaunchCorner.Parent = LaunchAllBtn

---------------------------------------------------------
-- TARGET SELECTION LOGIC (Mobile & PC Compatible)
---------------------------------------------------------
TargetBtn.MouseButton1Click:Connect(function()
    SelectingTarget = true
    TargetBtn.Text = "👉 Click/Tap anywhere on Map..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not SelectingTarget then return end

    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if (isMouse or isTouch) then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            TargetPosition = mouse.Hit.Position
            TargetBtn.Text = "✅ Target Set: (" .. math.floor(TargetPosition.X) .. ", " .. math.floor(TargetPosition.Z) .. ")"
            SelectingTarget = false
        end
    end
end)

---------------------------------------------------------
-- INSTANT MASS LAUNCH LOGIC
---------------------------------------------------------
LaunchAllBtn.MouseButton1Click:Connect(function()
    if not TargetPosition then
        TargetBtn.Text = "⚠️ Please Click Here To Set Target First!"
        task.wait(1.5)
        TargetBtn.Text = "🎯 Select Target Location"
        return
    end

    local rocketsFolder = Workspace:FindFirstChild("Rockets")
    if not rocketsFolder then
        LaunchAllBtn.Text = "❌ No Rockets Folder Found!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    local rocketsList = rocketsFolder:GetChildren()
    if #rocketsList == 0 then
        LaunchAllBtn.Text = "❌ No Rockets Available!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    -- Fire all rockets instantly without delay loop
    if LaunchRemote then
        for _, rocket in ipairs(rocketsList) do
            task.spawn(function()
                pcall(function()
                    LaunchRemote:FireServer(TargetPosition, rocket)
                end)
            end)
        end
        LaunchAllBtn.Text = "🚀 Launched (" .. tostring(#rocketsList) .. ") Rockets!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
    end
end)

-- Toggle GUI View (RightShift Key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
