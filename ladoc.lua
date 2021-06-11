local nelua = require 'ladoc.parsers.nelua'
local util = require 'ladoc.util'
local Emitter = require 'ladoc.emitter'

local function gendoc(emitter, filename, options)
  local source = util.readfile(filename)
  local ast = nelua.parser:parse(source, filename)
  local comments = nelua.parser:parse_comments(source, filename)
  nelua.generator:emit(source, filename, ast, comments, options, emitter)
end

local function gen_stdlib()
  local emitter = Emitter.create()

  emitter:add[[
---
layout: docs
title: Libraries
permalink: /libraries/
categories: docs toc
toc: true
order: 4
---

This is a list of Nelua standard libraries.
{: .lead}

To use a library, use `require 'libraryname'`{:.language-nelua}.
{: .callout.callout-info}

]]

  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/builtins.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/arg.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/iterators.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/io.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/filestream.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/math.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/memory.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/os.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/span.nelua', {
    include_names={spanT=true}
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/string.nelua', {
    include_names={string=true},
    top_template = [[
## $(name)

$(text)

### string

```nelua
global string = @record{
  data: *[0]byte,
  size: usize,
}
```

The string record defined in the compiler sources.

New strings always have the `data` buffer null terminated by default
to have more comparability with C APIs.
The `data` buffer is 0-indexed (unlike string APIs).
]]
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/stringbuilder.nelua', {
    include_names={stringbuilderT=true}
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/traits.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/utf8.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/coroutine.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/hash.nelua')
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/vector.nelua', {
    include_names={vectorT=true}
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/sequence.nelua', {
    include_names={sequenceT=true}
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/list.nelua', {
    include_names={listnodeT=true, listT=true}
  })
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/hashmap.nelua', {
    include_names={hashnodeT=true, hashmapT=true}
  })

  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/allocators/interface.nelua', {
    name='allocators.interface',
    include_names={Allocator=true}
  })

  emitter:add[[

<a href="/clibraries/" class="btn btn-outline-primary btn-lg float-right">C Libraries >></a>
]]

  local file = io.open('/home/bart/projects/nelua/nelua-lang/docs/pages/libraries.md','w')
  file:write(emitter:generate())
  file:close()
end

local function gen_clib()
  local emitter = Emitter.create()
  emitter:add[[
---
layout: docs
title: C libraries
permalink: /clibraries/
categories: docs toc
toc: true
order: 5
---

Nelua provides bindings for common C functions according to the C11 specification.
This is a list of all imported C libraries.
{: .lead}

To use a C library, use `require 'C.stdlib'`{:.language-nelua} for example.
{: .callout.callout-info}

Nelua encourages you to use it's standard libraries instead of the C APIs,
these are provided just as convenience for interoperating with C libraries.
{:.alert.alert-info}

]]
  -- gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/init.nelua', {name='C',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/arg.nelua', {name='C.arg',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/ctype.nelua', {name='C.ctype',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/errno.nelua', {name='C.errno',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/locale.nelua', {name='C.locale',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/math.nelua', {name='C.math',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/signal.nelua', {name='C.signal',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/stdarg.nelua', {name='C.stdarg',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/stdio.nelua', {name='C.stdio',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/stdlib.nelua', {name='C.stdlib',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/string.nelua', {name='C.string',include_names={C=true}})
  gendoc(emitter, '/home/bart/projects/nelua/nelua-lang/lib/C/time.nelua', {name='C.time',include_names={C=true}})

  local file = io.open('/home/bart/projects/nelua/nelua-lang/docs/pages/clibraries.md','w')
  file:write(emitter:generate())
  file:close()
end

gen_stdlib()
gen_clib()
