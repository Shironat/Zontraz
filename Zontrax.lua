local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()

-- Cria a janela
local Window = Zonix:CreateWindow({
    Name = "ZonixHub",
    Icons = {}
})

local Tabs = {}
Tabs.Main = Window:CreateTab("Main")
Tabs.Farm = Window:CreateTab("Farm")

local TsunamiEscape = require(script.TsunamiEscape)
TsunamiEscape:CreateToggle(Tabs.Main)