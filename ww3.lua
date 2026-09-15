-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Configuration Storage
local Config = {
    TargetPosition = nil,
    RocketAmount = 1,
    LaunchAll = false,
    ESPEnabled = false
}

-- Load Saved Config if exists
local ConfigFileName = "RocketScriptConfig.json"
if readfile and isfile and isfile(ConfigFileName) then
    pcall(function()
        local data = HttpService:JSONDecode(readfile(ConfigFileName))
        if data then
            Config.RocketAmount = data.RocketAmount or 1
            Config.LaunchAll = data.LaunchAll or false
            if data.TargetPosition then
                Config.TargetPosition = Vector3.new(data.TargetPosition.X, data.TargetPosition.Y, data.TargetPosition.Z)
            end
        end
    end)
end

local function SaveConfig()
    if writefile then
        local dataToSave = {
            RocketAmount = Config.RocketAmount,
            LaunchAll = Config.LaunchAll,
            TargetPosition = Config.TargetPosition and {X = Config.TargetPosition.X, Y = Config.TargetPosition.Y, Z = Config.TargetPosition.Z} or nil
        }
        writefile(ConfigFileName, HttpService:JSONEncode(dataToSave))
    end
end

-- Remotes (From Provided Images)
local MissileRemotes = Workspace:FindFirstChild("MissileAttackRemotes")
local LaunchRemote = MissileRemotes and MissileRemotes:FindFirstChild("MissileLaunchRequest")

-- Simple ScreenGui Builder
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RocketControlGUI"
ScreenGui.ResetOnSpawn = false

-- Executor Compatibility Check for Parent
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
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Header Title
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Header.Text = "🚀 Rocket Warfare Control Panel"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 16
Header.Font = Enum.Font.SourceSansBold
Header.Parent = MainFrame

-- Sidebar (Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -40)
Content.Position = UDim2.new(0, 120, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Content.BorderSizePixel = 0
Content.Parent = MainFrame

-- Tab Frames Table
local Tabs = {}
local TabButtons = {}

local TabNames = {"Main", "Combat", "Visuals", "Teleport", "Misc", "Settings"}

for i, name in ipairs(TabNames) do
    -- Create Tab Frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = name .. "Tab"
    TabFrame.Size = UDim2.new(1, -10, 1, -10)
    TabFrame.Position = UDim2.new(0, 5, 0, 5)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = (i == 1)
    TabFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    TabFrame.ScrollBarThickness = 4
    TabFrame.Parent = Content
    Tabs[name] = TabFrame

    -- Create Button
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Position = UDim2.new(0, 5, 0, (i - 1) * 40 + 5)
    Btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(50, 50, 65) or Color3.fromRGB(35, 35, 40)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.Parent = Sidebar

    TabButtons[name] = Btn

    Btn.MouseButton1Click:Connect(function()
        for tName, tFrame in pairs(Tabs) do
            tFrame.Visible = (tName == name)
            TabButtons[tName].BackgroundColor3 = (tName == name) and Color3.fromRGB(50, 50, 65) or Color3.fromRGB(35, 35, 40)
        end
    end)
end

---------------------------------------------------------
-- COMBAT TAB CONTROLS
---------------------------------------------------------
local CombatTab = Tabs["Combat"]

-- Set Target Button
local SetTargetBtn = Instance.new("TextButton")
SetTargetBtn.Size = UDim2.new(0.9, 0, 0, 35)
SetTargetBtn.Position = UDim2.new(0.05, 0, 0, 10)
SetTargetBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 150)
SetTargetBtn.Text = Config.TargetPosition and ("Target Set: " .. tostring(math.floor(Config.TargetPosition.X)) .. ", " .. tostring(math.floor(Config.TargetPosition.Z))) or "Select Target on Map (Click Ground)"
SetTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetTargetBtn.Font = Enum.Font.SourceSansBold
SetTargetBtn.TextSize = 14
SetTargetBtn.Parent = CombatTab

local SelectingTarget = false
SetTargetBtn.MouseButton1Click:Connect(function()
    SelectingTarget = true
    SetTargetBtn.Text = "Click anywhere in the game world..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if SelectingTarget and input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit then
            Config.TargetPosition = mouse.Hit.Position
            SetTargetBtn.Text = "Target Set: " .. math.floor(Config.TargetPosition.X) .. ", " .. math.floor(Config.TargetPosition.Y) .. ", " .. math.floor(Config.TargetPosition.Z)
            SaveConfig()
            SelectingTarget = false
        end
    end
end)

-- Amount Input Box
local AmountLabel = Instance.new("TextLabel")
AmountLabel.Size = UDim2.new(0.9, 0, 0, 20)
AmountLabel.Position = UDim2.new(0.05, 0, 0, 55)
AmountLabel.Text = "Rockets Count (1 - 100):"
AmountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AmountLabel.BackgroundTransparency = 1
AmountLabel.TextXAlignment = Enum.TextXAlignment.Left
AmountLabel.Parent = CombatTab

local AmountInput = Instance.new("TextBox")
AmountInput.Size = UDim2.new(0.9, 0, 0, 30)
AmountInput.Position = UDim2.new(0.05, 0, 0, 80)
AmountInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AmountInput.Text = tostring(Config.RocketAmount)
AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountInput.Parent = CombatTab

AmountInput.FocusLost:Connect(function()
    local num = tonumber(AmountInput.Text)
    if num then
        Config.RocketAmount = math.clamp(math.floor(num), 1, 100)
        AmountInput.Text = tostring(Config.RocketAmount)
        SaveConfig()
    end
end)

-- Launch All Toggle
local LaunchAllBtn = Instance.new("TextButton")
LaunchAllBtn.Size = UDim2.new(0.9, 0, 0, 30)
LaunchAllBtn.Position = UDim2.new(0.05, 0, 0, 120)
LaunchAllBtn.BackgroundColor3 = Config.LaunchAll and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(60, 60, 65)
LaunchAllBtn.Text = "Launch All Rockets: " .. (Config.LaunchAll and "ON" or "OFF")
LaunchAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchAllBtn.Parent = CombatTab

LaunchAllBtn.MouseButton1Click:Connect(function()
    Config.LaunchAll = not Config.LaunchAll
    LaunchAllBtn.BackgroundColor3 = Config.LaunchAll and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(60, 60, 65)
    LaunchAllBtn.Text = "Launch All Rockets: " .. (Config.LaunchAll and "ON" or "OFF")
    SaveConfig()
end)

-- LAUNCH BUTTON
local FireBtn = Instance.new("TextButton")
FireBtn.Size = UDim2.new(0.9, 0, 0, 45)
FireBtn.Position = UDim2.new(0.05, 0, 0, 160)
FireBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FireBtn.Text = "🔥 LAUNCH ROCKETS"
FireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FireBtn.Font = Enum.Font.SourceSansBold
FireBtn.TextSize = 18
FireBtn.Parent = CombatTab

FireBtn.MouseButton1Click:Connect(function()
    if not Config.TargetPosition then
        FireBtn.Text = "❌ Choose Target First!"
        task.wait(1.5)
        FireBtn.Text = "🔥 LAUNCH ROCKETS"
        return
    end

    local rocketsFolder = Workspace:FindFirstChild("Rockets")
    if not rocketsFolder then return end

    local availableRockets = rocketsFolder:GetChildren()
    local countToLaunch = Config.LaunchAll and #availableRockets or math.min(Config.RocketAmount, #availableRockets)

    for i = 1, countToLaunch do
        local rocket = availableRockets[i]
        if rocket and LaunchRemote then
            -- Sending Launch Remote Request with Target Position and Rocket Instance
            pcall(function()
                LaunchRemote:FireServer(Config.TargetPosition, rocket)
            end)
        end
    end
end)

---------------------------------------------------------
-- VISUALS TAB (ESP FOR ROCKETS)
---------------------------------------------------------
local VisualsTab = Tabs["Visuals"]

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 35)
ESPBtn.Position = UDim2.new(0.05, 0, 0, 10)
ESPBtn.BackgroundColor3 = Config.ESPEnabled and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(60, 60, 65)
ESPBtn.Text = "Rocket ESP: " .. (Config.ESPEnabled and "ENABLED" or "DISABLED")
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Parent = VisualsTab

local activeBillboards = {}

local function ClearESP()
    for _, b in pairs(activeBillboards) do
        b:Destroy()
    end
    table.clear(activeBillboards)
end

local function UpdateESP()
    ClearESP()
    if not Config.ESPEnabled then return end

    local rocketsFolder = Workspace:FindFirstChild("Rockets")
    if rocketsFolder then
        for _, rocket in ipairs(rocketsFolder:GetChildren()) do
            local targetPart = rocket:FindFirstChild("Root") or rocket:FindFirstChild("Collide") or rocket:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                local bb = Instance.new("BillboardGui")
                bb.Adornee = targetPart
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.AlwaysOnTop = true
                
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = rocket.Name
                txt.TextColor3 = Color3.fromRGB(255, 80, 80)
                txt.Font = Enum.Font.SourceSansBold
                txt.TextSize = 12
                txt.Parent = bb

                bb.Parent = ScreenGui
                table.insert(activeBillboards, bb)
            end
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    ESPBtn.BackgroundColor3 = Config.ESPEnabled and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(60, 60, 65)
    ESPBtn.Text = "Rocket ESP: " .. (Config.ESPEnabled and "ENABLED" or "DISABLED")
    UpdateESP()
end)

-- Auto-Refresh ESP on new rockets
if Workspace:FindFirstChild("Rockets") then
    Workspace.Rockets.ChildAdded:Connect(function()
        if Config.ESPEnabled then
            task.wait(0.2)
            UpdateESP()
        end
    end)
    Workspace.Rockets.ChildRemoved:Connect(function()
        if Config.ESPEnabled then
            UpdateESP()
        end
    end)
end

---------------------------------------------------------
-- KEYBIND TOGGLE (RightShift)
---------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
