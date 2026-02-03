print("Carregando Escape a Tsunami...")
local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()
print("Zonix: 200[OK]")

local Window = Rayfield:CreateWindow({
     Name = "ShiroHub v2",
     LoadingTitle = "Carregando...",
     LoadingSubtitle = "by Shiro",
     ShowText = "ShiroHub"})

print("Carregando Tabs...")
local Tabs = {}

Tabs.Tsunami  = Window:Tab("Tsunami")

assert(Tabs.Tsunami, "Tab Tsunami não existe")
print("Carregadando módulos...")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/ShiroHub-v2/main/Tabs/Tsunami.lua"))()(Tabs.Tsunami)
print("TSUNAMI: 200[OK]")

print("ShiroHub carregado!")