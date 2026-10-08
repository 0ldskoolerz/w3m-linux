-- audio-alsa.lua — volumen vía ALSA (amixer) para W3M Linux
-- Igual interfaz que audio.lua (pactl) pero con backend alsa-utils.
-- F8 = mute, F9 = bajar, F10 = subir
local last = 0
local cached = "..."

local function read_vol()
    local f = io.popen("amixer sget Master 2>/dev/null")
    if not f then return nil, nil end
    local out = f:read("*a") or ""
    f:close()
    if out == "" then return nil, nil end
    local pct = out:match("%[(%d+)%%%]")
    local mute = out:find("%[off%]") ~= nil
    return pct and tonumber(pct), mute
end

local function set_vol(delta)
    local pct = read_vol()
    if not pct then return end
    local target = math.max(0, math.min(100, pct + delta))
    os.execute(string.format("amixer sset Master %d%% >/dev/null 2>&1", target))
    cached = target .. "%"
end

function on_tick()
    local now = os.time()
    if now - last < 3 then return end
    last = now
    local pct, mute = read_vol()
    if pct then
        if mute then cached = "MUTE (" .. pct .. "%)"
        else cached = "VOL " .. pct .. "%" end
    else
        cached = "sin audio"
    end
    wm.status("audio", cached)
end

function on_key(code, name)
    if name == "F8" then
        os.execute("amixer sset Master toggle >/dev/null 2>&1")
    elseif name == "F9" then
        set_vol(-5)
    elseif name == "F10" then
        set_vol(5)
    end
    local pct, mute = read_vol()
    if pct then
        if mute then cached = "MUTE (" .. pct .. "%)"
        else cached = "VOL " .. pct .. "%" end
    end
    wm.status("audio", cached)
end
