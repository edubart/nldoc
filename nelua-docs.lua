local nldoc = require 'nldoc'

-- Generate standard libraries documentation.
local function gen_stdlib(neluadir)
  -- emitter used to concatenate documentation text
  local emitter = nldoc.Emitter.create()

  -- add documentation heading
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

  -- parse and generate documentation for many sources
  nldoc.generate_doc(emitter, neluadir..'/lib/builtins.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/arg.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/iterators.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/io.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/filestream.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/math.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/memory.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/os.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/span.nelua', {
    include_names={spanT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/string.nelua', {
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
  nldoc.generate_doc(emitter, neluadir..'/lib/stringbuilder.nelua', {
    include_names={stringbuilderT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/traits.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/utf8.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/coroutine.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/hash.nelua')
  nldoc.generate_doc(emitter, neluadir..'/lib/vector.nelua', {
    include_names={vectorT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/sequence.nelua', {
    include_names={sequenceT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/list.nelua', {
    include_names={listnodeT=true, listT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/hashmap.nelua', {
    include_names={hashnodeT=true, hashmapT=true}
  })

  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/default.nelua', {
    name='allocators.default',
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/allocator.nelua', {
    name='allocators.allocator',
    include_names={Allocator=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/general.nelua', {
    name='allocators.general',
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/gc.nelua', {
    name='allocators.gc',
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/arena.nelua', {
    name='allocators.arena',
    include_names={ArenaAllocatorT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/stack.nelua', {
    name='allocators.stack',
    include_names={StackAllocatorT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/pool.nelua', {
    name='allocators.pool',
    include_names={PoolAllocatorT=true}
  })
  nldoc.generate_doc(emitter, neluadir..'/lib/allocators/heap.nelua', {
    name='allocators.heap',
    include_names={HeapAllocatorT=true}
  })

  -- add documentation footer
  emitter:add[[

<a href="/clibraries/" class="btn btn-outline-primary btn-lg float-right">C Libraries >></a>
]]

  -- generate the documentation file
  local docfile = neluadir..'/docs/pages/libraries.md'
  nldoc.write_file(docfile, emitter:generate())
  print('generated', docfile)
end

-- Generate C libraries documentation.
local function gen_clib(neluadir)
  local emitter = nldoc.Emitter.create()

  -- add documentation heading
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

  -- parse and generate documentation for many sources
  nldoc.generate_doc(emitter, neluadir..'/lib/C/arg.nelua', {name='C.arg',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/ctype.nelua', {name='C.ctype',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/errno.nelua', {name='C.errno',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/locale.nelua', {name='C.locale',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/math.nelua', {name='C.math',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/signal.nelua', {name='C.signal',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/stdarg.nelua', {name='C.stdarg',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/stdio.nelua', {name='C.stdio',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/stdlib.nelua', {name='C.stdlib',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/string.nelua', {name='C.string',include_names={C=true}})
  nldoc.generate_doc(emitter, neluadir..'/lib/C/time.nelua', {name='C.time',include_names={C=true}})

  -- generate the documentation file
  local docfile = neluadir..'/docs/pages/clibraries.md'
  nldoc.write_file(docfile, emitter:generate())
  print('generated', docfile)
end

if not arg[1] then
  print 'Please pass the Nelua source directory as the first argument.'
  os.exit(1)
end

-- Generate documentation for Nelua libraries.
local neluadir = arg[1]
gen_stdlib(neluadir)
gen_clib(neluadir)
