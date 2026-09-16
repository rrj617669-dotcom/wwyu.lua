-- تحميل مكتبة WindUI
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

-- الخدمات واللاعب المحلي
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- المتغيرات العامة للسكربت
getgenv().AutoFire = false
getgenv().FireDelay = 0.05

-- إنشاء النافذة الرئيسية
local Window = WindUI:CreateWindow({
    Title = "Gun Controller Hub",
    Icon = "rbxassetid://10734943902",
    Author = "Roblox Developer",
    Folder = "GunScriptConfig",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
    HasOutline = true
})

-- إنشاء تبويب الأسلحة
local MainTab = Window:Tab({
    Title = "الأسلحة والقتال",
    Icon = "crosshair"
})

-- قسم التحكم بالإطلاق
MainTab:Section({ Title = "إعدادات السلاح (OnActivate)" })

-- زر تفعيل الإطلاق التلقائي
MainTab:Toggle({
    Title = "إطلاق نار تلقائي (Auto Fire)",
    Desc = "استدعاء OnActivate بشكل مستمر وسريع",
    Value = false,
    Callback = function(State)
        getgenv().AutoFire = State
    end
})

-- شريط التحكم بسرعة الإطلاق
MainTab:Slider({
    Title = "سرعة الإطلاق (Delay)",
    Desc = "المدة بين كل طلقة (بالثواني)",
    Step = 0.01,
    Value = { Min = 0.01, Max = 0.5, Default = 0.05 },
    Callback = function(Value)
        getgenv().FireDelay = Value
    end
})

-- زر تفعيل طلقة واحدة فورية
MainTab:Button({
    Title = "إطلاق طلقة فورية",
    Desc = "تفعيل OnActivate مرة واحدة فوراً",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("OnActivate") then
                tool.OnActivate:FireServer()
            end
        end
    end
})

-- الحلقة التكرارية للخلفية (Auto Fire Loop)
task.spawn(function()
    while true do
        if getgenv().AutoFire then
            local character = LocalPlayer.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                -- التحقق من وجود السلاح وريموت OnActivate
                if tool and tool:FindFirstChild("OnActivate") then
                    tool.OnActivate:FireServer()
                end
            end
        end
        task.wait(getgenv().FireDelay)
    end
end)
