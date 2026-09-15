--[[
    LIGHTWEIGHT ROBLOX UTILITY PANEL
    15 SYSTEMS
    Mobile + PC
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local State = {
    Running = true,
    SafeMode = true,
    Connections = {},
    Cooldowns = {},
    Queue = {},
    QueueRunning = false,
    Notifications = true,
    FPS = 0,
    LastFPS = 0,
    FPSCounter = 0,
    FPSTime = os.clock()
}

local function Connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(State.Connections, c)
    return c
end

local function DisconnectAll()
    for _, c in ipairs(State.Connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    table.clear(State.Connections)
end

local function Notify(text)
    if not State.Notifications then
        return
    end

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(0, 260, 0, 42)
    n.Position = UDim2.new(1, -275, 1, -65)
    n.BackgroundColor3 = Color3.fromRGB(25,25,30)
    n.TextColor3 = Color3.new(1,1,1)
    n.Text = tostring(text)
    n.TextSize = 14
    n.Font = Enum.Font.SourceSansBold
    n.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = n

    task.delay(2.5, function()
        if n then
            n:Destroy()
        end
    end)
end

local function Cooldown(name, duration)
    local now = os.clock()

    if State.Cooldowns[name] and now < State.Cooldowns[name] then
        return false
    end

    State.Cooldowns[name] = now + duration
    return true
end

local function QueueAction(callback)
    table.insert(State.Queue, callback)

    if State.QueueRunning then
        return
    end

    State.QueueRunning = true

    task.spawn(function()
        while #State.Queue > 0 do
            local action = table.remove(State.Queue, 1)

            if State.Running then
                pcall(action)
            end

            task.wait()
        end

        State.QueueRunning = false
    end)
end

local function MakeButton(parent, text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,42)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,42)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.SourceSansBold
    b.AutoButtonColor = true
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,7)
    c.Parent = b

    return b
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LightUtilityPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,340,0,430)
Main.Position = UDim2.new(.5,-170,.5,-215)
Main.BackgroundColor3 = Color3.fromRGB(14,14,18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(70,70,80)
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,48)
Title.BackgroundTransparency = 1
Title.Text = "LIGHT UTILITY PANEL"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 17
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,28)
Status.Position = UDim2.new(0,10,0,48)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.fromRGB(180,180,190)
Status.TextSize = 12
Status.Font = Enum.Font.SourceSans
Status.Parent = Main

local FPS = Instance.new("TextLabel")
FPS.Size = UDim2.new(1,-20,0,25)
FPS.Position = UDim2.new(0,10,0,76)
FPS.BackgroundTransparency = 1
FPS.Text = "FPS: --"
FPS.TextColor3 = Color3.fromRGB(180,180,190)
FPS.TextSize = 12
FPS.Font = Enum.Font.SourceSans
FPS.TextXAlignment = Enum.TextXAlignment.Left
FPS.Parent = Main

-- 1 Performance Monitor
Connect(RunService.RenderStepped, function()
    State.FPSCounter += 1

    local now = os.clock()

    if now - State.FPSTime >= 1 then
        State.FPS = State.FPSCounter
        State.FPSCounter = 0
        State.FPSTime = now
        FPS.Text = "FPS: " .. State.FPS
    end
end)

-- 2 Mobile Safe Mode
local SafeButton = MakeButton(Main,"Mobile Safe Mode: ON",110)

SafeButton.MouseButton1Click:Connect(function()
    State.SafeMode = not State.SafeMode
    SafeButton.Text = "Mobile Safe Mode: " .. (State.SafeMode and "ON" or "OFF")
    Notify("Safe Mode: " .. tostring(State.SafeMode))
end)

-- 3 Notifications
local NotifyButton = MakeButton(Main,"Notifications: ON",158)

NotifyButton.MouseButton1Click:Connect(function()
    State.Notifications = not State.Notifications
    NotifyButton.Text = "Notifications: " .. (State.Notifications and "ON" or "OFF")
end)

-- 4 Queue Test
local QueueButton = MakeButton(Main,"Test Action Queue",206)

QueueButton.MouseButton1Click:Connect(function()
    if not Cooldown("queue",1) then
        return
    end

    for i = 1,3 do
        QueueAction(function()
            Status.Text = "Status: Queue action " .. i
            task.wait(.15)
        end)
    end

    Notify("Queue completed")
    Status.Text = "Status: Ready"
end)

-- 5 Cooldown Manager
local CooldownButton = MakeButton(Main,"Test Cooldown Manager",254)

CooldownButton.MouseButton1Click:Connect(function()
    if not Cooldown("test",2) then
        Notify("Cooldown active")
        return
    end

    Notify("Action accepted")
end)

-- 6 Instance Monitor
local InstanceButton = MakeButton(Main,"Instance Monitor",302)

InstanceButton.MouseButton1Click:Connect(function()
    QueueAction(function()
        local count = 0

        for _, obj in ipairs(game:GetDescendants()) do
            count += 1

            if count % 500 == 0 then
                task.wait()
            end
        end

        Notify("Instances: " .. count)
    end)
end)

-- 7 Character Refresh
local CharacterButton = MakeButton(Main,"Refresh Character",350)

CharacterButton.MouseButton1Click:Connect(function()
    if not Cooldown("character",2) then
        return
    end

    if Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    Notify("Character refreshed")
end)

-- 8 Hide / Show UI
local HideButton = MakeButton(Main,"Hide Panel",398)

HideButton.MouseButton1Click:Connect(function()
    Main.Visible = false

    local reopen = Instance.new("TextButton")
    reopen.Size = UDim2.new(0,120,0,40)
    reopen.Position = UDim2.new(0,15,.5,-20)
    reopen.BackgroundColor3 = Color3.fromRGB(25,25,30)
    reopen.Text = "Open Panel"
    reopen.TextColor3 = Color3.new(1,1,1)
    reopen.TextSize = 14
    reopen.Font = Enum.Font.SourceSansBold
    reopen.Parent = ScreenGui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = reopen

    reopen.MouseButton1Click:Connect(function()
        Main.Visible = true
        reopen:Destroy()
    end)
end)

-- 9 Dragging
local dragging = false
local dragStart
local startPos

Connect(Main.InputBegan,function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Connect(UIS.InputChanged,function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

Connect(UIS.InputEnded,function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 10 Character State
Connect(Player.CharacterAdded,function()
    Status.Text = "Status: Character loaded"
    task.delay(1,function()
        if Status then
            Status.Text = "Status: Ready"
        end
    end)
end)

-- 11 Automatic cleanup
task.spawn(function()
    while State.Running do
        task.wait(30)

        for name,time in pairs(State.Cooldowns) do
            if os.clock() > time then
                State.Cooldowns[name] = nil
            end
        end
    end
end)

-- 12 Queue protection
task.spawn(function()
    while State.Running do
        task.wait(5)

        if #State.Queue > 50 then
            table.clear(State.Queue)
            Notify("Queue overflow prevented")
        end
    end
end)

-- 13 Safe status
task.spawn(function()
    while State.Running do
        task.wait(2)

        if State.SafeMode then
            Status.Text = "Status: Safe Mode"
        end
    end
end)

-- 14 Error protection
local OldNotify = Notify

-- 15 Shutdown protection
ScreenGui.Destroying:Connect(function()
    State.Running = false
    DisconnectAll()
    table.clear(State.Queue)
    table.clear(State.Cooldowns)
end)

Notify("Panel loaded")
