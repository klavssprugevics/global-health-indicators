local playerHealth = {}
local playerDamageHistory = {}


local function broadcastHealthInfoToClients()
    net.Start(GHI_NETWORK_STRINGS.healthInfo)
    net.WriteTable(playerHealth)
    net.WriteTable(playerDamageHistory)
    net.Broadcast()
end


hook.Add("PlayerSpawn", "ghi_player_spawn", function (ply)
    playerHealth[ply] = ply:Health()
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerDisconnected", "ghi_player_disconnected", function (ply)
    playerHealth[ply] = nil
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerHurt", "ghi_player_hurt", function(ply, attacker, healthRemaining, damageTaken)
    playerDamageHistory[ply] = -1 * math.Round(damageTaken)
    if healthRemaining < 0 then playerHealth[ply] = 0 else playerHealth[ply] = healthRemaining end
    broadcastHealthInfoToClients()
end)


-- There has to be a better way :D
hook.Add("Tick", "ghi_healed", function()
    for _, ply in pairs(player.GetAll()) do
        if playerHealth[ply] == nil then continue end
        if playerHealth[ply] < ply:Health() then
            playerDamageHistory[ply] = ply:Health() - playerHealth[ply]
            playerHealth[ply] = ply:Health()
            broadcastHealthInfoToClients()
        end
    end
end)
