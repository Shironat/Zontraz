local HttpGet = game.HttpGet
local player = game.Players.LocalPlayer

-- loader genérico
local function LoadModule(url)
    return loadstring(game:HttpGet(url))()
end

-- estado global do toggle
local AutoFarmState = { Enabled = false }

-- carrega módulo
local AutoFarm = LoadModule(
    "https://raw.githubusercontent.com/Shironat/Zontraz/main/modules/EvadeTsunami.lua"
)

-- Zonix UI
local Window = Zonix:CreateWindow({
    Title = "Zontrax",
    Center = true
})

local Tab = Window:AddTab("Farm")

Tab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        AutoFarmState.Enabled = value

        if value then
            AutoFarm(AutoFarmState)
        end
    end
})