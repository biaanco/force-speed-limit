-- Forced Pit Limiter under Yellow Flag (by ChatGPT)
-- Comandos en chat del cliente: "yellow" para activar, "green" para desactivar
-- Muestra HUD indicando estado y velocidad máxima

local yellowFlag = false
local limitSpeed = 80 / 3.6  -- 80 km/h en m/s

-- Función para activar bandera amarilla
function enableYellow()
    ac.log(">>> Yellow Flag ACTIVADA: todos limitados a 80 km/h")
    yellowFlag = true
end

-- Función para desactivar bandera amarilla
function disableYellow()
    ac.log(">>> Green Flag: limitador desactivado")
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

-- Ciclo de actualización: aplica pit limiter
function script.update(dt)
    for i, car in ac.iterateCars() do
        if car.isConnected then
            if yellowFlag then
                car.usePitLimiter = true
                car.pitLimiterSpeed = limitSpeed
            else
                car.usePitLimiter = false
            end
        end
    end
end

-- Dibuja HUD simple para todos los jugadores
function script.draw()
    local text = ""
    if yellowFlag then
        text = string.format("YELLOW FLAG ACTIVE - Max Speed: %d km/h", math.floor(limitSpeed * 3.6))
    else
        text = "GREEN FLAG - No Speed Limit"
    end

    -- Dibuja arriba a la izquierda
    ac.drawText(50, 50, text, 1, 1, 1, 1, 20)  -- x, y, texto, r,g,b,a, tamaño
end
