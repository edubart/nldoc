--[[
Util module, contains some utilities used in the code base.
]]

local lpegrex = require 'lpegrex'

local util = {}

--[[
Read a file and return its contents as string.
 In case of failure, returns nil plus and error.
 ]]
function util.readfile(filename)
  local file, err = io.open(filename)
  if not file then return err end
  local contents = file:read("*a")
  file:close()
  return contents
end

-- Walk iterator, used by `walk_nodes`.
local function walk_nodes_iterator(node, parent, parentindex)
  if node.tag then
    coroutine.yield(node, parent, parentindex)
  end
  for i=1,#node do
    local v = node[i]
    if type(v) == 'table' then
      walk_nodes_iterator(v, node, i)
    end
  end
end

-- Walk all nodes from an AST.
function util.walk_nodes(ast)
  return coroutine.wrap(walk_nodes_iterator), ast
end

local substitute_vars_mt = {}
local substitute_vars = setmetatable({}, substitute_vars_mt)
local substitute_defs = {}
function substitute_defs.to_var(k)
  local v = substitute_vars[k]
  return v ~= nil and tostring(v) or ''
end
local substitute_patt = lpegrex.compile([[
  pat <- {~ (var / .)* ~}
  var <- ('$(' {[_%a]+} ')') -> to_var
]], substitute_defs)

-- Substitute keywords between '$()' from a text using values from a table.
function util.substitute(format, vars)
  substitute_vars_mt.__index = vars
  return substitute_patt:match(format)
end

return util
