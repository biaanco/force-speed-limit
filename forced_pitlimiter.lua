-- Forced Pit Limiter under Yellow Flag (by ChatGPT)
-- Requiere Custom Shaders Patch en el servidor
-- Comandos en chat:
--   !yellow  -> Activa bandera amarilla (limitador ON)
--   !green   -> Desactiva bandera amarilla (limitador OFF)

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

-- Revisa mensajes de chat
function ac.onChatMessage(car, message)
  local lowerMsg = string.lower(message)

  if lowerMsg == "!yellow" and car.isAdmin then
    enableYellow()
    return true
  elseif lowerMsg == "!green" and car.isAdmin then
    disableYellow()
    return true
  end

  return false
end

-- Ciclo de actualización
function script.update(dt)
  if yellowFlag then
    for i, car in ac.iterateCars() do
      if car.isConnected then
        car.usePitLimiter = true
        car.pitLimiterSpeed = limitSpeed
      end
    end
  else
    for i, car in ac.iterateCars() do
      if car.isConnected then
        car.usePitLimiter = false
      end
    end
  end
end
