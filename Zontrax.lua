print("Carregando Escape a Tsunami...")

local Zonix = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zontrz/zonix-ui/main/main.lua"))()

print("Zonix: 200[OK]")

local Window = Zonix:Window({
    Name = "Escape Tsunami For Brainrot",
    Icon = {
        Type = "emoji",
        Value = "🏄"
    },
    MinimizeMode = "collapse",
    CompactMode = false})

print("Carregando Tabs...")
local Tabs = {}

Tabs.Autofarm  = Window:Tab({Name = "Auto farm"})
Tabs.Teleport  = Window:Tab({Name = "Teleport"})
Tabs.Player    = Window:Tab({Name = "Player"})
Tabs.Misc      = Window:Tab({Name = "Misc"})

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Autofarm.lua"))()(Tabs.Autofarm)
print("Autofarm: 200[OK]")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Teleport.lua"))()(Tabs.Teleport)
print("Teleport: 200[OK]")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Player.lua"))()(Tabs.Player)
print("Player: 200[OK]")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Misc.lua"))()(Tabs.Misc)
print("Misc: 200[OK]")


print("Zonix carregado!")