GHI_NETWORK_STRINGS = {
    ["healthInfo"] = "GHI_HEALTH_INFO",
}

if SERVER then
    for key, networkString in pairs(GHI_NETWORK_STRINGS) do
        util.AddNetworkString(networkString)
    end
end
