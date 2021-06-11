--[[
Parser class, used to parse source codes.
It's the base class for the language parsers.
]]

local lpegrex = require 'lpegrex'

local Parser = {}
local Parser_mt = {__index = Parser}

-- Creates a new Parser.
function Parser.create(grammar, comments_grammar, errors, defs)
  local source_patt = lpegrex.compile(grammar, defs)
  local comments_patt = lpegrex.compile(comments_grammar, defs)
  return setmetatable({
    source_patt = source_patt,
    comments_patt = comments_patt,
    errors = errors,
  }, Parser_mt)
end

local function parse_error(self, source, name, errlabel, errpos)
  name = name or '<source>'
  local lineno, colno, line = lpegrex.calcline(source, errpos)
  local colhelp = string.rep(' ', colno-1)..'^'
  local errmsg = self.errors[errlabel] or errlabel
  error('syntax error: '..name..':'..lineno..':'..colno..': '..errmsg..
        '\n'..line..'\n'..colhelp)
end

-- Parse source into an AST.
function Parser:parse(source, name)
  local ast, errlabel, errpos = self.source_patt:match(source)
  if not ast then
    parse_error(self, source, name, errlabel, errpos)
  end
  return ast
end

-- Remove left common left indentations from a text.
local function trim_identantion(text)
  local initcol, ss = 0x7fffffff, {}
  -- find common indentation
  for line in text:gmatch('([^\n]*)\n?') do
    if #line > 0 then
      local charcol = line:find('[^%s]')
      if charcol then
        initcol = math.min(initcol, charcol)
      end
    end
    ss[#ss+1] = line
  end
  -- remove common indentation and trim right
  for i=1,#ss do
    ss[i] = ss[i]:sub(initcol):gsub('%s*$', '')
  end
  return table.concat(ss, '\n')
end

-- Trim spaces from comments.
local function trim_comments(comments)
  for i=1,#comments do
    local comment = comments[i]
    comment.text = trim_identantion(comment.text)
  end
  -- remove empty comments
  local i = 1
  while i <= #comments do
    local comment = comments[i]
    if comment.text == '' then
      table.remove(comments, i)
    else
      i = i + 1
    end
  end
end

-- Calculate comments line numbers.
local function calc_comments(comments, source)
  -- gather line number and calc comment texts
  for i=1,#comments do
    local comment = comments[i]
    comment.text, comment[1] = comment[1], nil
    -- calculate line numbers
    comment.lineno, comment.colno = lpegrex.calcline(source, comment.pos)
    comment.endlineno, comment.endcolno = lpegrex.calcline(source, comment.endpos-1)
  end
end

-- Combine neighbor comments.
local function combine_comments(comments, source)
  local i = 1
  while i < #comments do
    local c1 = comments[i]
    local c2 = comments[i+1]
    local inbetween = source:sub(c1.endpos, c2.pos-1)
    if c1.colno == c2.colno and
       c1.endlineno+1 == c2.lineno and
       c1.tag == c2.tag and
       inbetween:match('^%s*$') then
      comments[i] = {
        tag = c1.tag,
        text = c1.text..'\n'..c2.text,
        pos = c1.pos,
        endpos = c2.endpos,
        lineno = c1.lineno,
        endlineno = c2.endlineno,
        colno = c1.colno,
        endcolno = c2.endcolno,
        combined = true,
      }
      table.remove(comments, i+1)
    else
      i = i + 1
    end
  end
  return comments
end

-- Convert a list of comments to a map of line number and comment.
local function make_comments_by_line(comments)
  local comments_by_line = {}
  for i=1,#comments do
    local comment = comments[i]
    for lineno=comment.lineno,comment.endlineno do
      assert(not comments_by_line[lineno])
      comments_by_line[lineno] = comment
    end
  end
  return comments_by_line
end

-- Parse all comments from source into a map and a list of comments.
function Parser:parse_comments(source, name)
  local comments, errlabel, errpos = self.comments_patt:match(source)
  if not comments then
    parse_error(self, source, name, errlabel, errpos)
  end
  calc_comments(comments, source)
  combine_comments(comments, source)
  trim_comments(comments)
  local comments_by_line = make_comments_by_line(comments)
  return comments_by_line, comments
end

return Parser
