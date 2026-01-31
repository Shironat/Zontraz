-- Main.lua (LocalScript)

-- Carrega a biblioteca Zonix
local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()

-- Cria a janela principal
local Window = Zonix:Window({
    Name = "Shiro Hub"
})

-- Cria as Tabs
local Tabs = {}
Tabs.Main = Window:Tab({
    Name = "Main"
})

Tabs.Farm = Window:Tab({
    Name = "Farm"
})

print("UI Zonix carregada e tabs criadas")

-- Carrega módulos
local Modules = script:WaitForChild("Modules")

local TsunamiEscape = require(Modules:WaitForChild("TsunamiEscape"))
local FarmCollectMoney = require(Modules:WaitForChild("FarmCollectMoney"))

print("CreateToggle chamado", Tab)
-- Cria toggles através dos módulos
TsunamiEscape:Toggle(Tabs.Main)
AutoMoney:Toggle(Tabs.Farm)