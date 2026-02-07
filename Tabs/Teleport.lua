return function(Tab)

        local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Logic/TeleportLogic.lua"))()

    Tab:Toggle({
    Name = "Auto Obby(money Event)",
    Callback = function(state)
        Logic.Enabled = state
    end
})