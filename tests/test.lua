local nelua_parser = require 'nldoc'.parser
local lester = require 'lester'

local describe, it, expect = lester.describe, lester.it, lester.expect

describe("parser", function()
  describe("Nelua", function()
    it("source", function()
      expect.equal(nelua_parser:parse([[print 'hello world']]),
        { { { { "hello world",
                endpos = 20,
                pos = 7,
                tag = "String"
              } }, { "print",
              endpos = 7,
              pos = 1,
              tag = "Id"
            },
            endpos = 20,
            pos = 7,
            tag = "Call"
          },
          endpos = 20,
          pos = 1,
          tag = "Block"
        })
    end)

    describe("comments", function()
      it("short", function()
        expect.equal(
          select(2, nelua_parser:parse_comments("-- line comment \n")),
          {{text="line comment", tag="ShortComment",
            pos=1, endpos=17, lineno=1, endlineno=1, colno=1, endcolno=16}})
      end)

      it("long", function()
        expect.equal(
          select(2, nelua_parser:parse_comments("--[[  \n  multi line\ncomment  \n  ]]  \n")),
          {{text="  multi line\ncomment", tag="LongComment",
            pos=1, endpos=35, lineno=1, endlineno=4, colno=1, endcolno=4, eq=""}})
        expect.equal(
          select(2, nelua_parser:parse_comments("--[==[  \n  multi line\ncomment  \n  ]==]  \n")),
          {{text="  multi line\ncomment", tag="LongComment",
            pos=1, endpos=39, lineno=1, endlineno=4, colno=1, endcolno=6, eq="=="}})
      end)

      it("trim indentation", function()
        expect.equal(
          select(2, nelua_parser:parse_comments([==[--[=[
            long

            comment
          ]=]]==])),
          {{text="long\n\ncomment", tag="LongComment",
            pos=1, endpos=58, lineno=1, endlineno=5, colno=1, endcolno=13, eq="="}})
        expect.equal(
          select(2, nelua_parser:parse_comments([==[--[=[
            long
            indented
            comment
          ]=]]==])),
          {{text="long\nindented\ncomment", tag="LongComment",
            pos=1, endpos=78, lineno=1, endlineno=5, colno=1, endcolno=13, eq="="}})
      end)

      it("combine", function()
        expect.equal(
          select(2, nelua_parser:parse_comments([==[
-- line1
--
-- line2
          ]=]]==])),
          {{text="line1\n\nline2", tag="ShortComment",
            pos=1, endpos=21, lineno=1, endlineno=3, colno=1, endcolno=8, combined=true}})
      end)
    end)
  end)
end)

lester.report()
