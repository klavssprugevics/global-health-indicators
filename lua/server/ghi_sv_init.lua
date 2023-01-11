local playerDead = {}
local playerHealth = {}
local playerDamageHistory = {}

local function printInfo()
    print("##############################")
    PrintTable(playerDead)
    print("----------------------")
    PrintTable(playerHealth)
    print("----------------------")
    PrintTable(playerDamageHistory)
    print("##############################")
end

hook.Add("PlayerSpawn", "ghi_player_spawn", function (ply)
    print(ply:Name() .. " joined.")
    playerDead[ply] = false
    playerHealth[ply] = ply:Health()
    playerDamageHistory[ply] = nil
    printInfo()
end)

hook.Add("PlayerDisconnected", "ghi_player_disconnected", function (ply)
    print(ply:Name() .. " disconnected.")
    playerDead[ply] = nil
    playerHealth[ply] = nil
    playerDamageHistory[ply] = nil
    printInfo()
end)

hook.Add("PlayerDeath", "ghi_player_dies", function(ply)
    print(ply:Name() .. " died.")
    playerDead[ply] = true
    printInfo()
end)

hook.Add("PlayerHurt", "ghi_player_hurt", function(ply, attacker, healthRemaining, damageTaken)
    print("[" .. healthRemaining .. "] " .. ply:Name() ..  " got hurt. (-" .. damageTaken ..")")
    playerDamageHistory[ply] = math.Round(damageTaken)
    if healthRemaining < 0 then playerHealth[ply] = 0 else playerHealth[ply] = healthRemaining end
    printInfo()
end)
