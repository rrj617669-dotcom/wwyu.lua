-- Universal No Recoil (Hooking Camera & ViewModel)
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- تعديل الـ CFrame الخاص بالكاميرا لمنع الاهتزاز أثناء الإطلاق
local OldIndex
OldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and self == Camera and (key == "CFrame" or key == "Focus") then
        -- إرجاع القيمة الأصلية بدون أي تعديلات طارئة من سكربت السلاح
    end
    return OldIndex(self, key)
end)
