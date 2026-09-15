-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Target Variables
local TargetPosition = nil
local SelectingTarget = false

-- Remote Setup
local MissileRemotes = Workspace:FindFirstChild("MissileAttackRemotes", true)
local LaunchRemote = MissileRemotes and MissileRemotes:FindFirstChild("MissileLaunchRequest")

if not LaunchRemote then
    LaunchRemote = Workspace:FindFirstChild("MissileLaunchRequest", true)
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiRocketLauncherUI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 210)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Header.Text = "🚀 Rocket Auto-Scanner Launcher"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 15
Header.Font = Enum.Font.SourceSansBold
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

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

-- Target Selection Logic
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

-- Smart Rocket Collector Function
local function FindRocketsInGame()
    local rocketsFound = {}
    
    -- 1. Search directly in Workspace for model pattern "Rocket_RT"
    for _, item in ipairs(Workspace:GetDescendants()) do
        if item.Name:sub(1, 9) == "Rocket_RT" or item.Name:sub(1, 8) == "AntiAir_" then
            table.insert(rocketsFound, item)
        elseif item.Name == "Rockets" or item.Name == "Missiles" then
            for _, r in ipairs(item:GetChildren()) do
                table.insert(rocketsFound, r)
            end
        end
    end
    
    return rocketsFound
end

-- Launch Execution Logic
LaunchAllBtn.MouseButton1Click:Connect(function()
    if not TargetPosition then
        TargetBtn.Text = "⚠️ Please Set Target First!"
        task.wait(1.5)
        TargetBtn.Text = "🎯 Select Target Location"
        return
    end

    if not LaunchRemote then
        LaunchRemote = Workspace:FindFirstChild("MissileLaunchRequest", true)
    end

    if not LaunchRemote then
        LaunchAllBtn.Text = "❌ Remote Event Missing!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    local rockets = FindRocketsInGame()

    if #rockets == 0 then
        LaunchAllBtn.Text = "❌ No Active Rockets Found!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    -- Fire all discovered rockets simultaneously
    for _, rocket in ipairs(rockets) do
        task.spawn(function()
            pcall(function()
                LaunchRemote:FireServer(TargetPosition, rocket)
            end)
        end)
    end

    LaunchAllBtn.Text = "🚀 Launched " .. tostring(#rockets) .. " Rockets!"
    task.wait(1.5)
    LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
end)
