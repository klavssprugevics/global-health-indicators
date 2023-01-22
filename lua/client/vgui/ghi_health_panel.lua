local WIDTH = 300
local HEIGHT = 500
local MARGIN_X = 20
local MARGIN_Y = 100
local PADDING = 10
local START_X = ScrW() - WIDTH - MARGIN_X
local START_Y = ScrH() / 2 - ScrH() / 4
local BAR_HEIGHT = 30

local c_background = Color(110, 110, 110, 200)
local c_health_bg = Color(61, 61, 61, 200)
local c_health = Color(204, 0, 0, 200)
local c_text_alive = Color(255, 255, 255, 255)
local c_text_dead = Color(255, 0, 0)
local c_text_healing = Color(140, 255, 0)

local function drawBackground()
    surface.SetDrawColor(c_background)
    surface.DrawRect(START_X, START_Y, WIDTH, #player.GetAll() * (BAR_HEIGHT + PADDING) + PADDING)
end

local function drawNameTag(ply, counter)
    surface.SetFont("GHINameFont")
    if ply:Alive() then surface.SetTextColor(c_text_alive) else surface.SetTextColor(c_text_dead) end
    surface.SetTextPos(START_X + PADDING + 5, START_Y + PADDING + counter * (BAR_HEIGHT + PADDING))
    local name = ply:Name()
    if string.len(name) > 10 then
        name = string.sub(name, 0, 10) .. ".."
    end
    surface.DrawText(name)
end

local function drawHealthText(ply, counter)
    surface.SetFont("GHIHealthFont")
    if ply:Alive() then surface.SetTextColor(c_text_alive) else surface.SetTextColor(c_text_dead) end
    surface.SetTextPos(START_X + PADDING + 120, START_Y + 12 + counter * (BAR_HEIGHT + PADDING))
    local health = GHI_HEALTH_INFO.playerHealth[ply]
    local healthLabel = health
    if health <= 0 then
        healthLabel = "   0"
    elseif health < 10 then
        healthLabel = "   " .. healthLabel
    elseif health < 100 then 
        healthLabel = "  " .. healthLabel 
    end
    surface.DrawText(healthLabel)
end

local function drawDamageText(ply, counter)
    if GHI_HEALTH_INFO.playerDamageHistory[ply] == nil then return end
    surface.SetFont("GHIHealthFont")
    if ply:Alive() then surface.SetTextColor(c_text_alive) else surface.SetTextColor(c_text_dead) end
    local damage = GHI_HEALTH_INFO.playerDamageHistory[ply]
    local xOffset = 42 + 11 * string.len(damage)
    if damage < 0 then 
        xOffset = 42 + 9 * (string.len(damage) - 1)
    end
    surface.SetTextPos(START_X + WIDTH - xOffset, START_Y + 12 + counter * (BAR_HEIGHT + PADDING))
    local damageLabel = "("
    if damage > 0 then
        surface.SetTextColor(c_text_healing)
        damageLabel = damageLabel .. "+" 
    end
    damageLabel = damageLabel .. damage .. ")"
    surface.DrawText(damageLabel)
end

local function drawHealthBackground(ply, counter)
    if GHI_HEALTH_INFO.playerHealth[ply] == nil then return end
    surface.SetDrawColor(c_health_bg)
    surface.DrawRect(START_X + PADDING, START_Y + PADDING + counter * (BAR_HEIGHT + PADDING), 
                     WIDTH - PADDING * 2, BAR_HEIGHT)
end

local function drawHealth(ply, counter)
    local healthPercentage = GHI_HEALTH_INFO.playerHealth[ply] / 100 * (WIDTH - PADDING * 2)
    surface.SetDrawColor(c_health)
    surface.DrawRect(START_X + PADDING, START_Y + PADDING + counter * (BAR_HEIGHT + PADDING), 
                     healthPercentage, BAR_HEIGHT)
end

local function drawPlayerInfo(ply, counter)
    drawHealthBackground(ply, counter)
    drawHealth(ply, counter)
end


hook.Add("HUDPaint", "ghi_draw_health_panel", function()
    if not GetConVar("ghi_enabled"):GetBool() then return end
    if table.IsEmpty(GHI_HEALTH_INFO.playerHealth) then return end
    for i, ply in pairs(player.GetAll()) do
        if i == 1 then drawBackground() end
        if GHI_HEALTH_INFO.playerHealth[ply] == nil then continue end
        drawPlayerInfo(ply, i - 1)
        drawNameTag(ply, i - 1)
        if GetConVar("ghi_draw_health_text"):GetBool() then 
            drawHealthText(ply, i - 1)
        end
        if GetConVar("ghi_draw_last_damage"):GetBool() then 
            drawDamageText(ply, i - 1)
        end
    end
end)
