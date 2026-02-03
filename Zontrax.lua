print("Carregando Escape a Tsunami...")
local Zonix = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zontrz/zonix-ui/refs/heads/main/main.lua"))()
print("Zonix: 200[OK]")

local Window = Zonix:Window({
     Name = "Escape Tsunami for Brainrot"
     Icons = {
          Type: "emoji",
          Value: "🏄" 
     }
)}

print("Carregando Tabs...")
local Tabs = {}

Tabs.Autofarm  = Window:Tab("Auto farm")
Tabs.Teleport  = Window:Tab("Teleport")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Autofarm.lua"))()(Tabs.Autofarm)
print("Autofarm: 200[OK]")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Tabs/Teleport.lua"))()(Tabs.Teleport)
print("Teleport: 200[OK]")


print("Zonix carregado!")