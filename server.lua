RegisterNetEvent("Nzdx-Penambang:Add", function(data)
    if exports.ox_inventory:CanCarryItem(source, data.item, data.amount) then
        exports.ox_inventory:AddItem(source, data.item, data.amount)
    end
end)

RegisterNetEvent("Nzdx-Penambang:Remove", function(data)
    exports.ox_inventory:RemoveItem(source, data.item, data.amount)
end)