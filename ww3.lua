-- ==========================================
-- UNIVERSAL ROCKET LAUNCHER & REMOTE SCANNER
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Global Variables
local TargetPosition = nil
local SelectingTarget = false
local CachedLaunchRemote = nil

-- Services List for Deep Scanning
local ServicesToScan = {
    Workspace,
    ReplicatedStorage,
    game:GetService("RobloxReplicatedStorage"),
    game:GetService("JointsService")
}

---------------------------------------------------------
-- DEEP REMOTE SCANNER FUNCTION
---------------------------------------------------------
local function FindLaunchRemote()
    if CachedLaunchRemote and CachedLaunchRemote.Parent then
        return CachedLaunchRemote
    end

    -- Known potential names for the remote
    local targetNames = {
        "MissileLaunchRequest",
        "LaunchMissile",
        "LaunchRocket",
        "RocketFire",
        "FireMissile",
        "AttackRemote"
    }

    for _, service in ipairs(ServicesToScan) do
        pcall(function()
            for _, descendant in ipairs(service:GetDescendants()) do
                if descendant:IsA("RemoteEvent") or descendant:IsA("UnreliableRemoteEvent") then
                    for _, name in ipairs(targetNames) do
                        if string.find(descendant.Name:lower(), name:lower()) then
                            CachedLaunchRemote = descendant
                            return
                        end
                    end
                end
            end
        end)
        if CachedLaunchRemote then break end
    end

    return CachedLaunchRemote
end

---------------------------------------------------------
-- ROCKET SCANNER FUNCTION
---------------------------------------------------------
local function FindAllRockets()
    local rocketsFound = {}

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            local name = descendant.Name
            if string.find(name, "Rocket_RT") or string.find(name, "AntiAir_") or name == "Rocket" or name == "Missile" then
                table.insert(rocketsFound, descendant)
            elseif name == "Rockets" or name == "Missiles" then
                for _, child in ipairs(descendant:GetChildren()) do
                    table.insert(rocketsFound, child)
                end
            end
        end)
    end

    return rocketsFound
end

---------------------------------------------------------
-- GUI CREATION MODULE
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalRocketSystem"
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
MainFrame.Size = UDim2.new(0, 330, 0, 220)
MainFrame.Position = UDim2.new(0.5, -165, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(45, 45, 55)
FrameStroke.Thickness = 1.5
FrameStroke.Parent = MainFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Header.Text = "🚀 Universal Rocket Controller"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 15
Header.Font = Enum.Font.SourceSansBold
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0.9, 0, 0, 45)
TargetBtn.Position = UDim2.new(0.05, 0, 0, 58)
TargetBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 210)
TargetBtn.Text = "🎯 Select Target Location"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.SourceSansBold
TargetBtn.TextSize = 14
TargetBtn.Parent = MainFrame

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 8)
TargetCorner.Parent = TargetBtn

local LaunchAllBtn = Instance.new("TextButton")
LaunchAllBtn.Size = UDim2.new(0.9, 0, 0, 55)
LaunchAllBtn.Position = UDim2.new(0.05, 0, 0, 118)
LaunchAllBtn.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
LaunchAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchAllBtn.Font = Enum.Font.SourceSansBold
LaunchAllBtn.TextSize = 15
LaunchAllBtn.Parent = MainFrame

local LaunchCorner = Instance.new("UICorner")
LaunchCorner.CornerRadius = UDim.new(0, 8)
LaunchCorner.Parent = LaunchAllBtn

---------------------------------------------------------
-- INTERACTION & LAUNCH HANDLERS
---------------------------------------------------------
TargetBtn.MouseButton1Click:Connect(function()
    SelectingTarget = true
    TargetBtn.Text = "👉 Click/Tap on Map Target..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not SelectingTarget then return end

    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if (isMouse or isTouch) then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            TargetPosition = mouse.Hit.Position
            TargetBtn.Text = "✅ Target: (" .. math.floor(TargetPosition.X) .. ", " .. math.floor(TargetPosition.Z) .. ")"
            SelectingTarget = false
        end
    end
end)

LaunchAllBtn.MouseButton1Click:Connect(function()
    if not TargetPosition then
        TargetBtn.Text = "⚠️ Set Target Location First!"
        task.wait(1.5)
        TargetBtn.Text = "🎯 Select Target Location"
        return
    end

    local remote = FindLaunchRemote()
    if not remote then
        LaunchAllBtn.Text = "❌ Remote Not Found In Any Service!"
        task.wait(2)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    local rockets = FindAllRockets()
    if #rockets == 0 then
        LaunchAllBtn.Text = "❌ No Active Rockets Found!"
        task.wait(1.5)
        LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
        return
    end

    local firedCount = 0
    for _, rocket in ipairs(rockets) do
        task.spawn(function()
            pcall(function()
                remote:FireServer(TargetPosition, rocket)
                firedCount = firedCount + 1
            end)
        end)
    end

    LaunchAllBtn.Text = "🚀 Fired (" .. tostring(#rockets) .. ") Targets!"
    task.wait(2)
    LaunchAllBtn.Text = "💥 LAUNCH ALL ROCKETS NOW"
end)
