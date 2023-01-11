GHI_HEALTH_INFO = GHI_HEALTH_INFO or {
    ["playerDead"] = {},
    ["playerHealth"] = {},
    ["playerDamageHistory"] = {}
} 

net.Receive(GHI_NETWORK_STRINGS.healthInfo, function(len)
    GHI_HEALTH_INFO.playerHealth = net.ReadTable()
    GHI_HEALTH_INFO.playerDamageHistory = net.ReadTable()
    GHI_HEALTH_INFO.playerDead = net.ReadTable()
    printInfo()
end)
