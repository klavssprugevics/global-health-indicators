local function sendClientScripts()
    AddCSLuaFile("autorun/ghi_load_scripts.lua")
    AddCSLuaFile("client/ghi_cl_init.lua")
    AddCSLuaFile("shared/ghi_network_strings.lua")
end

local function loadServerScripts()
    include("server/ghi_sv_init.lua")
end

local function loadClientScripts()
    include("client/ghi_cl_init.lua")
    include("shared/ghi_network_strings.lua")
end

if SERVER then
    sendClientScripts()
    loadServerScripts()
end

if CLIENT then
    loadClientScripts()
end
