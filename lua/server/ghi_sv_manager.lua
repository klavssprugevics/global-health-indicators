local playerHealth = {}
local playerDamageHistory = {}
local _tickCounter = 0

CreateClientConVar("ghi_sv_enabled", "1", true, false)
CreateClientConVar("ghi_sv_console_log", "1", true, false)

local function broadcastHealthInfoToClients()
    net.Start(GHI_NETWORK_STRINGS.healthInfo)
    net.WriteTable(playerHealth)
    net.WriteTable(playerDamageHistory)
    net.Broadcast()
end

local function logDamage(victim, damage)
    if not GetConVar("ghi_sv_console_log"):GetBool() then return end
    outString = victim:Name()
    if damage > 0 then
        outString = outString  .. " healed for " ..  damage 
    else
        outString = outString  .. " got damaged for " .. damage
    end
    print(outString)
end

hook.Add("PlayerSpawn", "ghi_player_spawn", function (ply)
    if not GetConVar("ghi_sv_enabled"):GetBool() then return end
    playerHealth[ply] = ply:Health()
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerDisconnected", "ghi_player_disconnected", function (ply)
    if not GetConVar("ghi_sv_enabled"):GetBool() then return end
    playerHealth[ply] = nil
    playerDamageHistory[ply] = nil
    broadcastHealthInfoToClients()
end)

hook.Add("PlayerHurt", "ghi_player_hurt", function(ply, attacker, healthRemaining, damageTaken)
    if not GetConVar("ghi_sv_enabled"):GetBool() then return end
    playerDamageHistory[ply] = -1 * math.Round(damageTaken)
    if healthRemaining < 0 then playerHealth[ply] = 0 else playerHealth[ply] = healthRemaining end
    broadcastHealthInfoToClients()
    logDamage(ply, playerDamageHistory[ply])
end)


hook.Add("Tick", "ghi_healed", function()
    if not GetConVar("ghi_sv_enabled"):GetBool() then return end
    if _tickCounter == 10 then 
        _tickCounter = 0
    else 
        _tickCounter = _tickCounter + 1
        return
    end

    for _, ply in pairs(player.GetAll()) do
        if playerHealth[ply] == nil then continue end
        if playerHealth[ply] < ply:Health() then
            playerDamageHistory[ply] = ply:Health() - playerHealth[ply]
            playerHealth[ply] = ply:Health()
            broadcastHealthInfoToClients()
            logDamage(ply, playerDamageHistory[ply])
        end
    end
end)
