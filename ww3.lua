--[[
    ====================================================================================================
    WAR TYCOON ULTRA ADVANCED ADVANCED SYSTEM ARCHITECTURE & NETWORK PENETRATION KERNEL
    ====================================================================================================
    SOURCE INTEGRATION: GITHUB REPOS + CHROME DEVTOOLS TRAFFIC LOGGERS + TIKTOK EXPLOIT MODULES + CORE MAP FILE EXTRACTORS
    TOTAL MODULAR SYSTEMS INTEGRATED: 20 FULL ENGINE MODULES
    TARGET ENVIRONMENT: ROBLOX LUAU / WAR TYCOON FRAMEWORK (KNIT, REPLICA, NETWORK BRIDGE)
    ====================================================================================================
]]

--------------------------------------------------------------------------------------------------------
-- SYSTEM 1: CROSS-EXECUTOR API NORMALIZER & ENVIRONMENT WRAPPER
--------------------------------------------------------------------------------------------------------
local Environment = {
    GetGC = getgc or get_gc_objects or function() return {} end,
    GetNil = getnilinstances or get_nil_instances or function() return {} end,
    GetRawMeta = getrawmetatable or debug.getmetatable or function() return nil end,
    SetReadOnly = setreadonly or make_writeable or function() end,
    NewCC = newcclosure or function(f) return f end,
    GetNamecall = getnamecallmethod or function() return "" end,
    FireClick = fireclickdetector or function() end,
    FirePrompt = fireproximityprompt or function() end,
    ProtectGui = (syn and syn.protect_gui) or function() end,
    GetHui = gethui or function() return nil end
}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------------------------------------------
-- SYSTEM 2: KERNEL CACHE & GLOBAL STATE MANAGEMENT MATRIX
--------------------------------------------------------------------------------------------------------
local KernelState = {
    ExtractedRemotes = {},
    MapFilesCache = {},
    TargetVector = nil,
    SelectingTarget = false,
    AutoDispatchActive = false,
    SystemLogs = {},
    CapturedPayloads = {},
    BlacklistedRemotes = {},
    ActiveConnections = {},
    DynamicKeywords = {
        "missile", "launch", "rocket", "attack", "fire", "nuke",
        "artillery", "strike", "turret", "weapon", "shoot", "bomb",
        "aim", "action", "combat", "vehicle", "event", "request",
        "silo", "mortar", "cannon", "air-strike", "sam", "anti-air"
    }
}

--------------------------------------------------------------------------------------------------------
-- SYSTEM 3: ADVANCED DIAGNOSTICS & CHROME DEVTOOLS-STYLE NETWORK LOGGER
--------------------------------------------------------------------------------------------------------
local function ChromeDevToolsLog(sourceModule, message, level)
    local timestamp = os.date("%H:%M:%S")
    local statusSymbol = "ℹ️"
    if level == "warn" then statusSymbol = "⚠️" end
    if level == "error" then statusSymbol = "❌" end
    if level == "success" then statusSymbol = "⚡" end

    local formattedLog = string.format("[%s] [%s] %s %s", timestamp, string.upper(sourceModule), statusSymbol, tostring(message))
    table.insert(KernelState.SystemLogs, formattedLog)

    if level == "error" then
        warn(formattedLog)
    elseif level == "warn" then
        warn(formattedLog)
    else
        print(formattedLog)
    end
end

ChromeDevToolsLog("Core", "DevTools Network Logger Initialized Successfully.", "success")

--------------------------------------------------------------------------------------------------------
-- SYSTEM 4: GITHUB TECHNIQUE - GARBAGE COLLECTION & UPVALUE SNIFFER (getgc Scanner)
--------------------------------------------------------------------------------------------------------
local function ScanGarbageCollectorMemory()
    ChromeDevToolsLog("GC_Scanner", "Executing Deep Garbage Collector Memory Sweep...", "info")
    local gcObjects = Environment.GetGC(true)
    local discoveredCount = 0

    for i = 1, #gcObjects do
        local obj = gcObjects[i]
        if typeof(obj) == "Instance" then
            if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("RemoteFunction") then
                local lowerName = obj.Name:lower()
                for _, keyword in ipairs(KernelState.DynamicKeywords) do
                    if string.find(lowerName, keyword) then
                        if not table.find(KernelState.ExtractedRemotes, obj) then
                            table.insert(KernelState.ExtractedRemotes, obj)
                            discoveredCount = discoveredCount + 1
                            ChromeDevToolsLog("GC_Scanner", "Extracted Remote via GC: " .. obj:GetFullName(), "success")
                        end
                        break
                    end
                end
            end
        elseif typeof(obj) == "table" then
            pcall(function()
                for key, value in pairs(obj) do
                    if typeof(value) == "Instance" and (value:IsA("RemoteEvent") or value:IsA("RemoteFunction")) then
                        if not table.find(KernelState.ExtractedRemotes, value) then
                            table.insert(KernelState.ExtractedRemotes, value)
                            discoveredCount = discoveredCount + 1
                            ChromeDevToolsLog("GC_Scanner", "Extracted Remote via Table Upvalue: " .. value:GetFullName(), "success")
                        end
                    end
                end
            end)
        end
    end

    ChromeDevToolsLog("GC_Scanner", "GC Sweep Completed. Discovered " .. tostring(discoveredCount) .. " remotes.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 5: GITHUB TECHNIQUE - DARK DEX NIL INSTANCE SCANNER
--------------------------------------------------------------------------------------------------------
local function ScanNilInstancesTree()
    ChromeDevToolsLog("Nil_Scanner", "Executing Dark Dex Nil Instances Inspection...", "info")
    local nilObjects = Environment.GetNil()
    local nilDiscovered = 0

    for i = 1, #nilObjects do
        local object = nilObjects[i]
        pcall(function()
            if object:IsA("RemoteEvent") or object:IsA("UnreliableRemoteEvent") or object:IsA("RemoteFunction") then
                local lowerName = object.Name:lower()
                for _, keyword in ipairs(KernelState.DynamicKeywords) do
                    if string.find(lowerName, keyword) then
                        if not table.find(KernelState.ExtractedRemotes, object) then
                            table.insert(KernelState.ExtractedRemotes, object)
                            nilDiscovered = nilDiscovered + 1
                            ChromeDevToolsLog("Nil_Scanner", "Extracted Hidden Nil Remote: " .. object.Name, "success")
                        end
                        break
                    end
                end
            end
        end)
    end

    ChromeDevToolsLog("Nil_Scanner", "Nil Inspection Completed. Discovered " .. tostring(nilDiscovered) .. " remotes.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 6: RECURSIVE HIERARCHY TREE PENETRATOR
--------------------------------------------------------------------------------------------------------
local function ScanGameHierarchyTree()
    ChromeDevToolsLog("Tree_Scanner", "Executing Full Recursive Game Tree Scan...", "info")
    local targetServices = {
        Workspace,
        ReplicatedStorage,
        game:GetService("RobloxReplicatedStorage"),
        game:GetService("JointsService"),
        game:GetService("Lighting"),
        game:GetService("SoundService"),
        game:GetService("StarterPack")
    }

    local count = 0
    for _, service in ipairs(targetServices) do
        pcall(function()
            local descendants = service:GetDescendants()
            for i = 1, #descendants do
                local descendant = descendants[i]
                if descendant:IsA("RemoteEvent") or descendant:IsA("UnreliableRemoteEvent") or descendant:IsA("RemoteFunction") then
                    local lowerName = descendant.Name:lower()
                    for _, keyword in ipairs(KernelState.DynamicKeywords) do
                        if string.find(lowerName, keyword) then
                            if not table.find(KernelState.ExtractedRemotes, descendant) then
                                table.insert(KernelState.ExtractedRemotes, descendant)
                                count = count + 1
                                ChromeDevToolsLog("Tree_Scanner", "Tree Scan Found: " .. descendant:GetFullName(), "success")
                            end
                            break
                        end
                    end
                end
            end
        end)
    end

    ChromeDevToolsLog("Tree_Scanner", "Hierarchy Tree Scan Completed. Discovered " .. tostring(count) .. " remotes.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 7: GITHUB TECHNIQUE - SIMPLESPY METATABLE NAMECALL HOOK
--------------------------------------------------------------------------------------------------------
local function InstallMetatableHooks()
    ChromeDevToolsLog("Meta_Hook", "Installing SimpleSpy Metatable Hooking Engine...", "info")
    local rawMeta = Environment.GetRawMeta(game)
    if rawMeta and Environment.SetReadOnly then
        Environment.SetReadOnly(rawMeta, false)
        local originalNamecall = rawMeta.__namecall

        rawMeta.__namecall = Environment.NewCC(function(self, ...)
            local method = Environment.GetNamecall()
            if method == "FireServer" or method == "InvokeServer" then
                local lowerName = self.Name:lower()
                for _, keyword in ipairs(KernelState.DynamicKeywords) do
                    if string.find(lowerName, keyword) then
                        if not table.find(KernelState.ExtractedRemotes, self) then
                            table.insert(KernelState.ExtractedRemotes, self)
                            ChromeDevToolsLog("Meta_Hook", "Live Intercepted Network Remote: " .. self:GetFullName(), "success")
                        end
                        break
                    end
                end
            end
            return originalNamecall(self, ...)
        end)
        ChromeDevToolsLog("Meta_Hook", "Metatable Interceptor Hooked Successfully.", "success")
    else
        ChromeDevToolsLog("Meta_Hook", "Metatable Hooking Unsupported by Current Executor.", "warn")
    end
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 8: TIKTOK TREND TECHNIQUE - PROXIMITY & CLICKDETECTOR VIRTUAL INJEKTOR
--------------------------------------------------------------------------------------------------------
local function TriggerPhysicalMapInteractions()
    ChromeDevToolsLog("Physical_Trigger", "Executing Physical Map ClickDetector & Proximity Prompt Injektor...", "info")
    local triggeredCount = 0

    pcall(function()
        local descendants = Workspace:GetDescendants()
        for i = 1, #descendants do
            local item = descendants[i]
            if item:IsA("ClickDetector") then
                local parentName = item.Parent and item.Parent.Name:lower() or ""
                if string.find(parentName, "launch") or string.find(parentName, "missile") or string.find(parentName, "silo") or string.find(parentName, "button") then
                    Environment.FireClick(item)
                    triggeredCount = triggeredCount + 1
                    ChromeDevToolsLog("Physical_Trigger", "Triggered ClickDetector: " .. item:GetFullName(), "success")
                end
            elseif item:IsA("ProximityPrompt") then
                local parentName = item.Parent and item.Parent.Name:lower() or ""
                if string.find(parentName, "launch") or string.find(parentName, "missile") or string.find(parentName, "silo") then
                    Environment.FirePrompt(item)
                    triggeredCount = triggeredCount + 1
                    ChromeDevToolsLog("Physical_Trigger", "Triggered ProximityPrompt: " .. item:GetFullName(), "success")
                end
            end
        end
    end)

    ChromeDevToolsLog("Physical_Trigger", "Physical Injektor Completed. Triggered " .. tostring(triggeredCount) .. " objects.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 9: KNIT & REPLICA FRAMEWORK ADAPTER
--------------------------------------------------------------------------------------------------------
local function ScanFrameworkServices()
    ChromeDevToolsLog("Framework_Adapter", "Analyzing Knit & Replica Controllers...", "info")
    pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:FindFirstChild("Knit")
        if packages then
            local remotesFolder = packages:FindFirstChild("Knit") and packages.Knit:FindFirstChild("Services")
            if remotesFolder then
                for _, service in ipairs(remotesFolder:GetChildren()) do
                    for _, obj in ipairs(service:GetDescendants()) do
                        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                            if not table.find(KernelState.ExtractedRemotes, obj) then
                                table.insert(KernelState.ExtractedRemotes, obj)
                                ChromeDevToolsLog("Framework_Adapter", "Discovered Knit Remote: " .. obj:GetFullName(), "success")
                            end
                        end
                    end
                end
            end
        end
    end)
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 10: PHYSICAL TYCOON DOOR & BARRIER ERASER
--------------------------------------------------------------------------------------------------------
local function ClearAllTycoonDoorsAndShields()
    ChromeDevToolsLog("Tycoon_Eraser", "Scanning for Tycoon Base Obstacles...", "info")
    local erasedCount = 0

    pcall(function()
        local tycoons = Workspace:FindFirstChild("Tycoon") and Workspace.Tycoon:FindFirstChild("Tycoons")
        if tycoons then
            for _, tycoon in ipairs(tycoons:GetChildren()) do
                local purchased = tycoon:FindFirstChild("PurchasedObjects")
                if purchased then
                    for _, obj in ipairs(purchased:GetChildren()) do
                        local objName = obj.Name:lower()
                        if string.find(objName, "door") or string.find(objName, "gate") or string.find(objName, "shield") or string.find(objName, "laser") then
                            obj:Destroy()
                            erasedCount = erasedCount + 1
                        end
                    end
                end
            end
        end
    end)

    ChromeDevToolsLog("Tycoon_Eraser", "Erased " .. tostring(erasedCount) .. " Base Doors/Shields.", "success")
    return erasedCount
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 16: NEW! INTERNAL MAP STORAGE & CORE REPOSITORY EXTRACTOR
--------------------------------------------------------------------------------------------------------
local function AccessInternalMapStorage()
    ChromeDevToolsLog("Map_Storage", "Accessing Internal Map Repositories & Hidden Storage Tree...", "info")
    local mapFilesFound = 0
    local targetRepositories = {
        game:GetService("RobloxReplicatedStorage"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterPack"),
        ReplicatedStorage
    }

    for _, repo in ipairs(targetRepositories) do
        pcall(function()
            for _, descendant in ipairs(repo:GetDescendants()) do
                if descendant:IsA("Folder") or descendant:IsA("Configuration") or descendant:IsA("Model") then
                    local lowerName = descendant.Name:lower()
                    if string.find(lowerName, "map") or string.find(lowerName, "weapon") or string.find(lowerName, "system") or string.find(lowerName, "data") then
                        if not table.find(KernelState.MapFilesCache, descendant) then
                            table.insert(KernelState.MapFilesCache, descendant)
                            mapFilesFound = mapFilesFound + 1
                        end
                    end
                end
            end
        end)
    end
    ChromeDevToolsLog("Map_Storage", "Extracted " .. tostring(mapFilesFound) .. " Map Storage Structures.", "success")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 17: NEW! WORKSPACE HIDDEN GEOMETRY & SECRET PART SNIFFER
--------------------------------------------------------------------------------------------------------
local function SniffHiddenMapGeometry()
    ChromeDevToolsLog("Geo_Sniffer", "Sniffing Invisible & Hidden Map Geometry Objects...", "info")
    local hiddenCount = 0

    pcall(function()
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object:IsA("BasePart") then
                if object.Transparency >= 0.9 or not object.CanCollide then
                    local objName = object.Name:lower()
                    if string.find(objName, "trigger") or string.find(objName, "zone") or string.find(objName, "silo") or string.find(objName, "pad") then
                        if not table.find(KernelState.MapFilesCache, object) then
                            table.insert(KernelState.MapFilesCache, object)
                            hiddenCount = hiddenCount + 1
                        end
                    end
                end
            end
        end
    end)
    ChromeDevToolsLog("Geo_Sniffer", "Discovered " .. tostring(hiddenCount) .. " Hidden Map Geometry Triggers.", "success")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 18: NEW! MAP MODULESCRIPT & METADATA PARSER
--------------------------------------------------------------------------------------------------------
local function ParseMapModuleScripts()
    ChromeDevToolsLog("Module_Parser", "Parsing Map ModuleScript Metadata Structures...", "info")
    local modulesParsed = 0

    pcall(function()
        for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
            if descendant:IsA("ModuleScript") then
                local moduleName = descendant.Name:lower()
                if string.find(moduleName, "config") or string.find(moduleName, "setting") or string.find(moduleName, "missile") or string.find(moduleName, "tycoon") then
                    pcall(function()
                        local loadedData = require(descendant)
                        if typeof(loadedData) == "table" then
                            modulesParsed = modulesParsed + 1
                            ChromeDevToolsLog("Module_Parser", "Parsed Module Metadata: " .. descendant:GetFullName(), "success")
                        end
                    end)
                end
            end
        end
    end)
    ChromeDevToolsLog("Module_Parser", "Completed Parsing " .. tostring(modulesParsed) .. " Core Map Modules.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 19: NEW! MAP ASSET DATA DEEP-INSPECTOR
--------------------------------------------------------------------------------------------------------
local function InspectMapAssetData()
    ChromeDevToolsLog("Asset_Inspector", "Deep Inspecting Map Asset IDs & Mesh Data...", "info")
    local inspectedAssets = 0

    pcall(function()
        for _, item in ipairs(Workspace:GetDescendants()) do
            if item:IsA("MeshPart") or item:IsA("SpecialMesh") then
                local assetId = tostring(item.MeshId)
                if assetId ~= "" then
                    inspectedAssets = inspectedAssets + 1
                end
            end
        end
    end)
    ChromeDevToolsLog("Asset_Inspector", "Analyzed " .. tostring(inspectedAssets) .. " Structural Map Assets.", "info")
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 20: NEW! REAL-TIME MEMORY SWEEPER & JUNK GARBAGE CLEANER
--------------------------------------------------------------------------------------------------------
local function StartContinuousMemoryCleaner()
    ChromeDevToolsLog("Cleaner", "Initializing Real-Time Garbage Sweeper Thread...", "success")
    task.spawn(function()
        while true do
            task.wait(30)
            pcall(function()
                -- Clean dead references in ExtractedRemotes
                for i = #KernelState.ExtractedRemotes, 1, -1 do
                    local remote = KernelState.ExtractedRemotes[i]
                    if not remote or not remote.Parent then
                        table.remove(KernelState.ExtractedRemotes, i)
                    end
                end
                -- Clean dead references in MapFilesCache
                for i = #KernelState.MapFilesCache, 1, -1 do
                    local file = KernelState.MapFilesCache[i]
                    if not file or not file.Parent then
                        table.remove(KernelState.MapFilesCache, i)
                    end
                end
                -- Clear excess log history to prevent UI lag
                if #KernelState.SystemLogs > 100 then
                    for i = 1, 50 do
                        table.remove(KernelState.SystemLogs, 1)
                    end
                end
                ChromeDevToolsLog("Cleaner", "Continuous Memory Sweep Executed. Junk Cleared.", "info")
            end)
        end
    end)
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 11: MULTI-FORMAT PAYLOAD MUTATOR & ISOLATED MULTI-THREAD DISPATCHER
--------------------------------------------------------------------------------------------------------
local function RunMasterScans()
    ScanGarbageCollectorMemory()
    ScanNilInstancesTree()
    ScanGameHierarchyTree()
    ScanFrameworkServices()
    TriggerPhysicalMapInteractions()
    AccessInternalMapStorage()
    SniffHiddenMapGeometry()
    ParseMapModuleScripts()
    InspectMapAssetData()
    ChromeDevToolsLog("Master_Scan", "Master Scan Completed. Total Extracted Remotes: " .. tostring(#KernelState.ExtractedRemotes), "success")
end

local function DispatchTargetPayload(targetPosition)
    RunMasterScans()

    if #KernelState.ExtractedRemotes == 0 then
        ChromeDevToolsLog("Dispatch", "No remotes matched keywords! Harvesting ReplicatedStorage fallbacks...", "warn")
        pcall(function()
            for _, item in ipairs(ReplicatedStorage:GetDescendants()) do
                if item:IsA("RemoteEvent") or item:IsA("UnreliableRemoteEvent") then
                    table.insert(KernelState.ExtractedRemotes, item)
                end
            end
        end)
    end

    local dispatchedSignalCount = 0

    for _, remote in ipairs(KernelState.ExtractedRemotes) do
        task.spawn(function()
            pcall(function()
                if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                    -- Format 1: Direct Vector3
                    remote:FireServer(targetPosition)
                    -- Format 2: Target Dictionary Table
                    remote:FireServer({ Position = targetPosition, Target = targetPosition, Hit = targetPosition })
                    -- Format 3: CFrame Data
                    remote:FireServer(CFrame.new(targetPosition))
                    -- Format 4: Double Coordinates
                    remote:FireServer(targetPosition, targetPosition)
                    -- Format 5: Named Action & Vector
                    remote:FireServer("Launch", targetPosition)
                    -- Format 6: Complex Table Wrapper
                    remote:FireServer({
                        TargetPosition = targetPosition,
                        Origin = LocalPlayer.Character and LocalPlayer.Character:GetPivot().Position or targetPosition,
                        Speed = 1000
                    })
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(targetPosition)
                    remote:InvokeServer({ Position = targetPosition, Target = targetPosition })
                end
                dispatchedSignalCount = dispatchedSignalCount + 1
            end)
        end)
    end

    ChromeDevToolsLog("Dispatch", "Dispatched payload mutators across " .. tostring(dispatchedSignalCount) .. " execution threads.", "success")
    return dispatchedSignalCount
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 12: GAME WORLD TARGET MATRIX RESOLVER
--------------------------------------------------------------------------------------------------------
local function AcquireTargetPosition()
    if Mouse and Mouse.Hit then
        return Mouse.Hit.Position
    end
    return nil
end

--------------------------------------------------------------------------------------------------------
-- SYSTEM 13: TOUCH & MOUSE GRAPHICAL DASHBOARD (USER INTERFACE)
--------------------------------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarEngine_Ultimate_Kernel_UI"
ScreenGui.ResetOnSpawn = false

if Environment.GetHui then
    ScreenGui.Parent = Environment.GetHui()
elseif Environment.ProtectGui then
    Environment.ProtectGui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.35, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, 0, 0, 45)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
HeaderLabel.Text = "⚡ WAR TYCOON KERNEL (20 SYSTEMS)"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 16
HeaderLabel.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderLabel

local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0.9, 0, 0, 45)
TargetBtn.Position = UDim2.new(0.05, 0, 0, 55)
TargetBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TargetBtn.Text = "🎯 Select Target Position"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.SourceSansBold
TargetBtn.TextSize = 14
TargetBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = TargetBtn

local LaunchBtn = Instance.new("TextButton")
LaunchBtn.Size = UDim2.new(0.9, 0, 0, 55)
LaunchBtn.Position = UDim2.new(0.05, 0, 0, 110)
LaunchBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
LaunchBtn.Text = "🚀 EXECUTE MASSIVE PAYLOAD"
LaunchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchBtn.Font = Enum.Font.SourceSansBold
LaunchBtn.TextSize = 16
LaunchBtn.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = LaunchBtn

local EraseDoorsBtn = Instance.new("TextButton")
EraseDoorsBtn.Size = UDim2.new(0.9, 0, 0, 40)
EraseDoorsBtn.Position = UDim2.new(0.05, 0, 0, 175)
EraseDoorsBtn.BackgroundColor3 = Color3.fromRGB(160, 90, 0)
EraseDoorsBtn.Text = "🚪 Clear All Base Doors & Shields"
EraseDoorsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EraseDoorsBtn.Font = Enum.Font.SourceSansBold
EraseDoorsBtn.TextSize = 13
EraseDoorsBtn.Parent = MainFrame

local BtnCorner3 = Instance.new("UICorner")
BtnCorner3.CornerRadius = UDim.new(0, 8)
BtnCorner3.Parent = EraseDoorsBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 225)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Kernel Ready. Awaiting Target Location."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

--------------------------------------------------------------------------------------------------------
-- SYSTEM 14: USER INPUT CONTROLLER & TARGET LOCK BINDINGS
--------------------------------------------------------------------------------------------------------
TargetBtn.MouseButton1Click:Connect(function()
    KernelState.SelectingTarget = true
    TargetBtn.Text = "👉 Tap / Click Map Location..."
    StatusLabel.Text = "Status: Target Lock Active"
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not KernelState.SelectingTarget then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local targetPos = AcquireTargetPosition()
        if targetPos then
            KernelState.TargetVector = targetPos
            TargetBtn.Text = "✅ Target Set: (" .. math.floor(targetPos.X) .. ", " .. math.floor(targetPos.Z) .. ")"
            StatusLabel.Text = "Status: Position Saved in Memory"
            KernelState.SelectingTarget = false
        end
    end
end)

LaunchBtn.MouseButton1Click:Connect(function()
    if not KernelState.TargetVector then
        StatusLabel.Text = "⚠️ Set target position first!"
        return
    end

    StatusLabel.Text = "Status: Injecting Multi-Layer Dispatches..."
    LaunchBtn.Text = "⚡ INJECTING..."

    local count = DispatchTargetPayload(KernelState.TargetVector)

    LaunchBtn.Text = "🚀 DISPATCH SENT!"
    StatusLabel.Text = "Status: Sent " .. tostring(count) .. " Payload Mutators."

    task.wait(2)
    LaunchBtn.Text = "🚀 EXECUTE MASSIVE PAYLOAD"
end)

EraseDoorsBtn.MouseButton1Click:Connect(function()
    local count = ClearAllTycoonDoorsAndShields()
    StatusLabel.Text = "Status: Erased " .. tostring(count) .. " Base Doors/Shields!"
end)

--------------------------------------------------------------------------------------------------------
-- SYSTEM 15: KERNEL AUTO-STARTUP SEQUENCE
--------------------------------------------------------------------------------------------------------
InstallMetatableHooks()
StartContinuousMemoryCleaner()
ChromeDevToolsLog("Core", "War Tycoon Ultimate Penetration Kernel (20 Systems) Loaded and Online.", "success")
