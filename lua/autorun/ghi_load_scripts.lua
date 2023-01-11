local function sendClientScripts()
    AddCSLuaFile("autorun/rmv_load_scripts.lua")

end

local function loadServerScripts()
    include("server/rhi_sv_init.lua")
end

local function loadClientScripts()
    include("client/rhi_cl_init.lua")
end

if SERVER then
    sendClientScripts()
    loadServerScripts()
end

if CLIENT then
    loadClientScripts()
end