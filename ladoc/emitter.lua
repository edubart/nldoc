--[[
Emitter class, used to emit large texts.
]]

-- The emitter class.
local Emitter = {}
Emitter.__index = Emitter

-- Creates a new emitter.
function Emitter.create()
  return setmetatable({}, Emitter)
end

-- Appends a text.
function Emitter:add(s)
  self[#self+1] = s
end

-- Combine all texts.
function Emitter:generate()
  return table.concat(self)
end

return Emitter
