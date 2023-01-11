local playerDead = {}
local playerHealth = {}
local playerDamageHistory = {}


local function broadcastHealthInfoToClients()
    net.Start(GHI_NETWORK_STRINGS.healthInfo)
    net.WriteTable(playerHealth)
    net.WriteTable(playerDamageHistory)
    net.WriteTable(playerDead)
    net.Broadcast()
end


hook.Add("PlayerSpawn", "ghi_player_spawn", function (ply)
    playerDead[ply] = false
    playerHealth[ply] = ply:Health()
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerDisconnected", "ghi_player_disconnected", function (ply)
    playerDead[ply] = nil
    playerHealth[ply] = nil
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerDeath", "ghi_player_dies", function(ply)
    playerDead[ply] = true
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerHurt", "ghi_player_hurt", function(ply, attacker, healthRemaining, damageTaken)
    playerDamageHistory[ply] = math.Round(damageTaken)
    if healthRemaining < 0 then playerHealth[ply] = 0 else playerHealth[ply] = healthRemaining end
    broadcastHealthInfoToClients()
end)
