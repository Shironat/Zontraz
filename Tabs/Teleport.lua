return function(Tab)

        local TeleportLogic = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Logic/TeleportLogic.lua"))()

    Tab:Toggle({
    Name = "Auto Obby(money Event)",
    Callback = function(state)
        TeleportLogic.Enabled = state
    end
})
end