local function sendClientScripts()
    AddCSLuaFile("autorun/ghi_load_scripts.lua")
    AddCSLuaFile("client/ghi_configuration.lua")
    AddCSLuaFile("shared/ghi_network_strings.lua")
    AddCSLuaFile("client/vgui/ghi_fonts.lua")
    AddCSLuaFile("client/ghi_cl_receiver.lua")
    AddCSLuaFile("client/vgui/ghi_health_panel.lua")
end

local function loadServerScripts()
    include("shared/ghi_network_strings.lua")
    include("server/ghi_sv_manager.lua")
end

local function loadClientScripts()
    include("client/ghi_configuration.lua")
    include("shared/ghi_network_strings.lua")
    include("client/vgui/ghi_fonts.lua")
    include("client/ghi_cl_receiver.lua")
    include("client/vgui/ghi_health_panel.lua")
end


if SERVER then
    sendClientScripts()
    loadServerScripts()
end

if CLIENT then
    loadClientScripts()
end
