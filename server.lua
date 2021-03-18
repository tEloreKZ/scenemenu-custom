RegisterServerEvent('ZoneActivated')
AddEventHandler('ZoneActivated', function(message, speed, radius, x, y, z)
    if message then
        TriggerClientEvent('chatMessage', -1, message)
    end
    TriggerClientEvent('Zone', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('Disable')
AddEventHandler('Disable', function(blip)
    TriggerClientEvent('RemoveBlip', -1)
end)

RegisterServerEvent('GetData')
AddEventHandler('GetData', function(mode)
local identifiers = GetPlayerIdentifiers(source)
    if mode == "IP" then
        for k,v in pairs(identifiers) do
            if string.sub(v, 0, 3) == "ip:" then
                TriggerClientEvent('ReturnData', source, v)
            end
        end
    else
        for k,v in pairs(identifiers) do
            if string.sub(v, 0, 6) == "steam:" then
                TriggerClientEvent('ReturnData', source, v)
            end
        end
    end
end)

function SpawnSpikestrips(src, amount)
    if SpikeConfig.IdentifierRestriction then
        local player_identifier = PlayerIdentifier(SpikeConfig.Identifier, src)
        for a = 1, #SpikeConfig.IdentifierList do
            if SpikeConfig.IdentifierList[a] == player_identifier then
                TriggerClientEvent("Spikes:SpawnSpikes", src, {amount = amount, isRestricted = SpikeConfig.PedRestriction, pedList = SpikeConfig.PedList})
                break
            end
        end
    else
        TriggerClientEvent("Spikes:SpawnSpikes", src, {amount = amount, isRestricted = SpikeConfig.PedRestriction, pedList = SpikeConfig.PedList})
    end
end

---------------------------------------------------------------------------
-- Delete Spikestrips --
---------------------------------------------------------------------------
RegisterServerEvent("Spikes:TriggerDeleteSpikes")
AddEventHandler("Spikes:TriggerDeleteSpikes", function(netid)
    TriggerClientEvent("Spikes:DeleteSpikes", -1, netid)
end)

---------------------------------------------------------------------------
-- Get Player Identifier --
---------------------------------------------------------------------------
function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end