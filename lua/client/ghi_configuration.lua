GHI_CONVARS = GHI_CONVARS or {
    ["ghi_enabled"] = nil,
    ["ghi_draw_names"] = nil,
    ["ghi_draw_last_damage"] = nil
}

GHI_CONVARS["ghi_enabled"] = CreateClientConVar("ghi_enabled", "1", true, false)
GHI_CONVARS["ghi_draw_health_text"] = CreateClientConVar("ghi_draw_health_text", "1", true, false)
GHI_CONVARS["ghi_draw_last_damage"] = CreateClientConVar("ghi_draw_last_damage", "1", true, false)