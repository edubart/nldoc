--[[
Generator class, used to generate the documentation.
It's the base class for the language generators.
]]

local util = require 'ladoc.util'
local Emitter = require 'ladoc.emitter'

-- The generator class.
local Generator = {}
local Generator_mt = {__index = Generator}

-- Default symbol template.
local symbol_template = [[
### $(name)

```$(lang)
$(code)
```

$(text)

]]

-- Default heading template.
local top_template = [[
## $(name)

$(text)

]]

local bottom_template = [[
---
]]

-- Create a new generator from visitors.
function Generator.create(visitors, lang)
  return setmetatable({
    top_template = top_template,
    symbol_template = symbol_template,
    bottom_template = bottom_template,
    lang = lang,
    visitors = visitors
  }, Generator_mt)
end

-- Emit documentation.
function Generator:emit(source, filename, ast, comments, options, emitter)
  -- setup options
  options = options or {}
  options.include_names = options.include_names or {}
  options.top_template = options.top_template or self.top_template
  options.symbol_template = options.symbol_template or self.symbol_template
  -- create emitter
  if not emitter then
    emitter = Emitter.create()
  end
  -- create context
  local context = {
    ast = ast,
    source = source,
    filename = filename,
    options = options,
    comments = comments,
    lang = self.lang,
    symbols = {},
  }
  local visitors = self.visitors
  -- emit top heading
  local topcomment = comments[1]
  if topcomment and visitors.TopComment then
    visitors.TopComment(context, topcomment, emitter)
  end
  -- emit nodes
  for node, parent in util.walk_nodes(ast) do
    node.parent = parent
    local visit = visitors[node.tag]
    if visit then
      visit(context, node, emitter)
    end
  end
  emitter:add(bottom_template)
  return emitter
end

return Generator
