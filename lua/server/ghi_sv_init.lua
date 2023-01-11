hook.Add("PlayerInitialSpawn", "ghi_player_initial_spawn", function (ply)
    print(ply:Name() .. " joined.")
end)

hook.Add("PlayerDisconnected", "ghi_player_disconnected", function (ply)
    print(ply:Name() .. " disconnected.")
end)

hook.Add("PlayerDeath", "ghi_player_dies", function(ply)
    print(ply:Name() .. " died.")
end)

hook.Add("PlayerHurt", "ghi_player_hurt", function(ply, attacker, healthRemaining, damageTaken)
    print("[" .. healthRemaining .. "] " .. ply:Name() ..  " got hurt. (-" .. damageTaken ..")")
end)
