local Zonix = loadstring(game:HttpGet("https://hub.zon.su/zonix-ui.lua"))()

local HttpGet = game.HttpGet
local player = game.Players.LocalPlayer

-- loader genérico
local function LoadModule(url)
    return loadstring(game:HttpGet(url))()
end

local AutoDodgeState = { Enabled = false }

local AutoDodge = LoadModule(
    "https://raw.githubusercontent.com/Shironat/Zontraz/main/Modules/AutoDodgeTsunami.lua"
)

-- Zonix UI
local Window = Zonix:Window({
    Title = "Zontrax",
    Center = true
})

local Tab = Window:AddTab("Farm")

Tab:AddToggle({
    Name = "Auto Dodge Tsunami",
    Default = false,
    Callback = function(value)
        AutoDodgeState.Enabled = value
        if value then
            AutoDodge(AutoDodgeState)
        end
    end
})