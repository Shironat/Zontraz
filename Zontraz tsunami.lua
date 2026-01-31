local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()

local Window = Zonix:Window({
    Name = "ZonixHub",
    Icon = {}
})

-- Create a tab with icon
local Main = Window:Tab({
    Name = "Main",
    Icon = {}

local Antiwave = Main:Toggle({
    Name = "AntiWave",
    Default = false,
    Flag = "antiwave",
    Callback = function(value)
        print("Toggle is now:", value)
    end
})
