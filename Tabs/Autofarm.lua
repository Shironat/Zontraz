return function(Tab)
    local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/Shironat/Zontraz/main/Logic/FarmLogic.lua"))()

    local brainrots = {}
    local selectedSlot = nil
    local DropdownRef = nil

    local function LoadBrainrots()
        brainrots = Logic.GetBrainrots() or {}

        local options = {}
        for _, b in ipairs(brainrots) do
            table.insert(options, b.Name)
        end

        if not DropdownRef then
            DropdownRef = Tab:Dropdown({
                Name = "Selecionar Brainrot",
                Options = options,
                Callback = function(selected)
                    local selectedName

                    if type(selected) == "table" then
                       selectedName = selected.Name or selected[1]
                    else
                       selectedName = selected
                    end

                    print("selecionado:", selectedName)

                    selectedSlot = nil

                       for _, b in ipairs(brainrots) do
                    if b.Name == selectedName then
                       selectedSlot = b.Slot
                       print("[Tsunami] Slot selecionado:", selectedSlot)
                    break
                    end
                 end
              end
            })
            return
        end

        if DropdownRef.Refresh then
            DropdownRef:Update(options)
            selectedSlot = nil
        else
            warn("Dropdown não suporta Refresh()")
        end
    end

    AutoFarm:Section("Resets")

    Tab:Button({
        Name = "Reset Base",
        Callback = Logic.ResetBase
    })

    AutoFarm:Button({
        Name = "Atualizar Brainrots",
        Callback = LoadBrainrots
    })

    AutoFarm:Section("AutoFarms")

    AutoFarm:Toggle({
        Name = "Auto Collect",
        Callback = function(state)
            Logic.ToggleMoney(state)

            if state then
                task.delay(0.4, LoadBrainrots)
            end
        end
    })

    AutoFarm:Toggle({  
        Name = "Auto Event Coins",  
        Callback = function(enabled)  
           pcall(function()  
               Logic.ToggleMoney(enabled)  
           end)  
        end,  
    })  

    AutoFarm:Toggle({
        Name = "Auto Upgrade Speed",
        Callback = Logic.ToggleUpgradeSpeed
    })

    AutoFarm:Toggle({
        Name = "Auto Rebirth",
        Callback = Logic.ToggleRebirth
    })

    AutoFarm:Toggle({
        Name = "Auto Upgrade Brainrot",
        Callback = function(state)
            if not state then
               Logic.ToggleUpgrade(false, nil)
            return
            end

            if not selectedSlot then
               warn("Selecione um Brainrot primeiro")
            return
            end

        Logic.ToggleUpgrade(true, selectedSlot)
    end
})
end