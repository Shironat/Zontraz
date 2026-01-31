-- Main.lua (LocalScript)

print("Main iniciou")

local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()
print("UI carregada")

local Window = Zonix:CreateWindow({
    Name = "Shiro Hub",
    Size = UDim2.new(0, 500, 0, 400),
    Theme = "Dark"
})

print("Janela criada")

local Tabs = {}
Tabs.Main = Window:CreateTab("Main")
Tabs.Farm = Window:CreateTab("Farm")

print("Tabs criadas")

-- Ajuste o caminho se necessário
local TsunamiEscape = require(script.TsunamiEscape)
local FarmCollectMoney = require(script.FarmCollectMoney)

print("Módulos carregados")

TsunamiEscape:CreateToggle(Tabs.Main)
FarmCollectMoney:CreateToggle(Tabs.Farm)

print("Toggles criados")