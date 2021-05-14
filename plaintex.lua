--[[

A Pandoc writer to output Plain TeX.

]]

local notes = {}

function RawInline(s)
	return s
end

function Str(s)
	return s
	:gsub("—", "---")
	:gsub("–", "--")
	:gsub("“", "``")
	:gsub("”", "''")
	:gsub("‘", "`")
	:gsub("’", "'")
end

function Space()
	return " "
end

function SoftBreak()
	return "\n"
end

function Blocksep()
	return "\n\n"
end

function Para(s)
	return s
end

function DoubleQuoted(s)
	return "``" .. s .. "''"
end

function Emph(s)
	return "{\\it " .. s .. "}"
end

function Strong(s)
	return "{\\bf " .. s .. "}"
end

function Header(lvl, s, attr)
	return ("\\beginsection{%s}"):format(s)
end

function InlineMath(s)
	return "$" .. s .. "$"
end

function DisplayMath(s)
	return "$$" .. s .. "$$"
end

function Doc(body, metadata, variables)
	local buffer = {}
	local function add(s)
		table.insert(buffer, s)
	end

	for k,v in pairs(metadata) do
		add("\\newtoks\\" .. k)
		add("\\" .. k .. " = {" .. v .. "}")
	end
	add ""

	add(body)

	if #notes > 0 then
		add('<ol class="footnotes">')
		for _,note in pairs(notes) do
			add(note)
		end
		add('</ol>')
	end

	return table.concat(buffer,'\n') .. '\n\\bye\n'
end

local meta = {}
meta.__index =
	function(_, key)
		io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
		return function() return "" end
	end
setmetatable(_G, meta)
