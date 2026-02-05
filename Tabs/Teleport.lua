return function(Tab)

    Tab:Toggle({
    Name = "Auto Obby(money Event)",
    Callback = function(state)
        TeleportLogic.Enabled = state
    end
})