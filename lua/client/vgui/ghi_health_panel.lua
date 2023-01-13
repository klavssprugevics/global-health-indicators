local WIDTH = 300
local HEIGHT = 500
local MARGIN_X = 20
local MARGIN_Y = 100
local PADDING = 10
local START_X = ScrW() - WIDTH - MARGIN_X
local START_Y = MARGIN_Y
local BAR_HEIGHT = 30

local c_background = Color(110, 110, 110, 200)
local c_health_bg = Color(61, 61, 61, 200)
local c_health = Color(241, 78, 78, 200)
local c_text_alive = Color(255, 255, 255, 255)
local c_text_dead = Color(255, 0, 0)


function printInfo()
    print("##############################")
    PrintTable(GHI_HEALTH_INFO.playerDead)
    print("----------------------")
    PrintTable(GHI_HEALTH_INFO.playerHealth)
    print("----------------------")
    PrintTable(GHI_HEALTH_INFO.playerDamageHistory)
    print("##############################")
end

local function drawBackground()
    surface.SetDrawColor(c_background)
    surface.DrawRect(START_X, START_Y, WIDTH, HEIGHT)
end

local function drawNameTag(ply, counter)
    surface.SetFont("GHINameFont")
    if ply:Alive() then surface.SetTextColor(c_text_alive) else surface.SetTextColor(c_text_dead) end
    surface.SetTextPos(START_X + PADDING + 5, START_Y + PADDING + counter * (BAR_HEIGHT + PADDING))
    local name = string.rep(ply:Name(), 10, "")
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
    if health < 100 then 
        healthLabel = "  " .. healthLabel 
    elseif health < 10 then
        healthLabel = "   " .. healthLabel
    end
    surface.DrawText(healthLabel)
end

local function drawDamageText(ply, counter)
    if GHI_HEALTH_INFO.playerDamageHistory[ply] == nil then return end
    surface.SetFont("GHIHealthFont")
    if ply:Alive() then surface.SetTextColor(c_text_alive) else surface.SetTextColor(c_text_dead) end
    local damage = GHI_HEALTH_INFO.playerDamageHistory[ply]
    local xOffset = 35 + 11 * string.len(damage)
    surface.SetTextPos(START_X + WIDTH - xOffset, START_Y + 12 + counter * (BAR_HEIGHT + PADDING))
    local damageLabel = "(-" .. damage .. ")"
    surface.DrawText(damageLabel)
end

local function drawHealthBackground(ply, counter)
    if GHI_HEALTH_INFO.playerHealth[ply] == nil then return end
    surface.SetDrawColor(c_health_bg)
    surface.DrawRect(START_X + PADDING, START_Y + PADDING + counter * (BAR_HEIGHT + PADDING), 
                     WIDTH - PADDING * 2, BAR_HEIGHT)
end

local function drawHealth(ply, counter)
    if GHI_HEALTH_INFO.playerHealth[ply] == nil then return end
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
    drawBackground()
    for i, ply in pairs(player.GetAll()) do
        drawPlayerInfo(ply, i - 1)
        drawNameTag(ply, i - 1)
        drawHealthText(ply, i - 1)
        drawDamageText(ply, i - 1)
    end
end)
