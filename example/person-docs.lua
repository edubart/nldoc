local nldoc = require 'nldoc'

local emitter = nldoc.Emitter.create()

-- add documentation header
emitter:add[[
# Documentation

Just an example documentation.
This text goes in the top of the page.
]]

nldoc.generate_doc(emitter, 'example/person.nelua')

-- add documentation footer
emitter:add[[

You have reached the end of the documentation!
]]

nldoc.write_file('example/person.md', emitter:generate())
