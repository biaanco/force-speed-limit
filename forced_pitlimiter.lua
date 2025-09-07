-- Forced Speed Limiter under Yellow Flag (by ChatGPT)
-- Comandos en chat: "yellow" para activar, "green" para desactivar
-- Limita efectivamente la velocidad de todos los coches reduciendo torque

local yellowFlag = false
local maxSpeed = 80 / 3.6  -- 80 km/h en m/s

-- Función para activar bandera amarilla
function enableYellow()
    ac.log(">>> Yellow Flag ACTIVADA: limitando velocidad de todos los coches")
    yellowFlag = true
end

-- Función para desactivar bandera amarilla
function disableYellow()
    ac.log(">>> Green Flag: velocidad normal")
    yellowFlag = false
end

-- Revisa mensajes de chat (solo admins)
function ac.onChatMessage(car, message)
    local lowerMsg = string.lower(message)
    if lowerMsg == "yellow" and car.isAdmin then
        enableYellow()
        return true
    elseif lowerMsg == "green" and car.isAdmin then
        disableYellow()
        return true
    end
    return false
end

-- Función para limitar efectivamente la velocidad de un coche
local function applySpeedLimit(car)
    local currentSpeed = car.physics.speedKmh
    if currentSpeed > 80 then
        -- Reducir torque del motor para limitar velocidad
        local factor = 1 - ((currentSpeed - 80) / currentSpeed)
        if factor < 0 then factor = 0 end
        car.engineTorqueFactor = factor
    else
        car.engineTorqueFactor = 1  -- normal
    end
end

-- Ciclo de actualización
function script.update(dt)
    for i, car in ac.iterateCars() do
        if car.isConnected then
            if yellowFlag then

