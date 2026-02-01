local HttpGet = game.HttpGet
local player = game.Players.LocalPlayer

-- loader genérico
local function LoadModule(url)
    return loadstring(game:HttpGet(url))()
end

local function LoadModule(url)
    return loadstring(game:HttpGet(url))()
end

local AutoDodgeState = { Enabled = false }

local AutoDodge = LoadModule(
    "https://raw.githubusercontent.com/Shironat/Zontraz/refs/main/Modules/AutoDodgeTsunami.lua"
)

-- Zonix UI
local Window = Zonix:CreateWindow({
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
