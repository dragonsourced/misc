--[[

A Pandoc writer to output Plain TeX.

]]

local notes = {}

function Doc(body, metadata, variables)
	local buffer = {}
	local function add(s)
		table.insert(buffer, s)
	end

	local tokd = {}
	local tokv = {}
	local input = metadata.input or {}
	metadata.input = nil
	for k,v in pairs(metadata) do
		if type(v) == "table" and type(v[1]) == "string" then
			if table.concat(v):match "," then
				v = table.concat(v, "; ")
			else
				v = table.concat(v, ", ")
			end
		end
		if type(v) == "string" then
			table.insert(tokd, "\\newtoks\\" .. k)
			table.insert(tokv, "\\" .. k .. " = {" .. v .. "}")
		end
	end
	add(table.concat(tokd, '\n'))

	local s = [[\def\maketitle\par{]]
	for _, p in ipairs({
		{"title", [[\centerline{\the\title}]]},
		{"subtitle", [[\centerline{\the\subtitle}]]},
		{"author", [[\centerline{\the\author}]]},
		{"date", [[\centerline{\the\date}]]}
	}) do
		local k, v = p[1], p[2]
		if metadata[k] then
			s = s .. v
		end
	end
	s = s .. [[\bigskip\noindent}]]
	add(s)

	if #input > 0 then
		if type(input) == "table" then
			input = table.concat(input, "\n\\input ")
		end
		add("\\input " .. input)
	end
	add(table.concat(tokv, '\n'))
	add "\\maketitle"
	add ""

	add(body)
	add "\\bye"

	return table.concat(buffer,'\n') .. '\n'
end

function RawBlock(lang, s)
	if lang == "tex" then
		return s
	else
		return ""
	end
end

function RawInline(lang, s)
	if lang == "tex" then
		return s
	else
		return ""
	end
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

local meta = {}
meta.__index =
	function(_, key)
		io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
		return function() return "" end
	end
setmetatable(_G, meta)
