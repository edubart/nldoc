# NLDoc - Nelua Documentation Generator

This is tool to generate documentation for
[Nelua](https://github.com/edubart/nelua-lang) source files.

This library was created mainly to generate documentation for the Nelua
standard libraries,
but it can also be used to generate documentation for other projects,
though you may have to personalize or configure it for your needs.

This library is theoretically easy to hack in case needed,
it's just a single lua script, comments, and it does not
depend on anything other than [LPegRex](https://github.com/edubart/lpegrex) and Lua.

It contains the whole Nelua grammar definition inside,
theoretically this library could also be used to generate documentation for Lua sources,
because the Nelua grammar is a super-set of the Lua grammar.

## How it works

This library parses a source file twice,
the first parse outputs the complete AST for source file.
A second parse collects all line comments.
After both AST and comments are parsed, all AST nodes are
visited while collecting comments just before the AST node.
Just variable declarations and function definitions are considered for documentation.
Local symbols and variables are ignored in the documentation,
unless you optionally force a name to be included.
Finally documentation is emitted for filtered AST nodes using
a markdown template with gathered code and comment information,
this template can be customized.

The library design resembles how the Nelua compiler works internally,
but in a very simple manner, because like the Nelua compiler it has
a parser made in LPegRex, a visitor pattern to traverse the AST nodes,
and a generator to emit text, but here we emit documentation
instead of C code.

## Complex Example

The
[nelua-docs.lua](https://github.com/edubart/nldoc/blob/master/nelua-docs.lua) file
is used to generate documentation for in the Nelua website, specifically the
[libraries](https://nelua.io/libraries/)
and
[C libraries](https://nelua.io/clibraries/) pages.

Here is a quick how to generate that documentation:

```bash
git clone https://github.com/edubart/nelua-lang.git
git clone https://github.com/edubart/nldoc.git && cd nldoc
lua nelua-docs.lua ../nelua-lang
```

This requires Lua 5.4 and LPegRex to be installed, alternatively
you can run with `nelua --script`, as Nelua compiler comes with Lua 5.4 and LPegRex bundled:

```bash
nelua --script nelua-docs.lua ../nelua-lang
```

It will generate documentation according to the rules defined in `nelua-docs.lua`,
read the file to understand how it works.

## Small Example

The [example folder](https://github.com/edubart/nldoc/blob/master/example/)
contains a simple example on how to generate documentation for a small library:

- [example/person.nelua](https://github.com/edubart/nldoc/blob/master/example/person.nelua) the source file that will be parsed and documented.
- [example/person-docs.lua](https://github.com/edubart/nldoc/blob/master/example/person-docs.lua) a lua script that generates the documentation.
- [example/person.md](https://github.com/edubart/nldoc/blob/master/example/person.md) the generated documentation output in Markdown format.

To regenerate `example/person.md` run the following:

```bash
nelua --script example/person-docs.lua
```
