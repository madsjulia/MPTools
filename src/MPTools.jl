module MPTools

function getsymbols(needle::Number)
	return Set{Symbol}()
end

function getsymbols(needle::Symbol)
	return Set{Symbol}([needle])
end

function getsymbols(haystack::Expr)
	symbols = Set{Symbol}()
	if typeof(haystack.head) == Expr
		union!(symbols, getsymbols(haystack.head))
	elseif typeof(haystack.head) == Symbol
		union!(symbols, [haystack.head])
	end
	for i = 1:length(haystack.args)
		if typeof(haystack.args[i]) == Expr
			union!(symbols, getsymbols(haystack.args[i]))
		elseif typeof(haystack.args[i]) == Symbol
			union!(symbols, [haystack.args[i]])
		end
	end
	return symbols
end

function populateexpression(haystack::Symbol, vals::Dict)
	if haskey(vals, string(haystack))
		return :($(vals[string(haystack)]))
	end
end

function populateexpression(haystack::Expr, vals::Dict)
	newhaystack = deepcopy(haystack)
	populateexpression!(newhaystack, vals::Dict)
	return newhaystack
end

function populateexpression!(haystack::Expr, vals::Dict)
	if typeof(haystack.head) == Expr
		populateexpression!(haystack.head, vals)
	elseif typeof(haystack.head) == Symbol
		if haskey(vals, string(haystack.head))
			haystack.head = vals[string(haystack.head)]
		end
	end
	for i = 1:length(haystack.args)
		if typeof(haystack.args[i]) == Expr
			populateexpression!(haystack.args[i], vals)
		elseif typeof(haystack.args[i]) == Symbol
			if haskey(vals, string(haystack.args[i]))
				haystack.args[i] = vals[string(haystack.args[i])]
			end
		end
	end
end

function replacesymbol(haystack::Symbol, needle::Symbol, replacement)
	if haystack == needle
		return replacement
	else
		return haystack
	end
end

function replacesymbol(haystack::Expr, needle::Symbol, replacement)
	newhaystack = deepcopy(haystack)
	replacesymbol!(newhaystack, needle, replacement)
	return newhaystack
end

function replacesymbol(haystack::Number, needle::Symbol, replacement)
	return haystack
end

function replacesymbol!(haystack::Expr, needle::Symbol, replacement)
	if typeof(haystack.head) == Expr
		replacesymbol!(haystack.head, needle, replacement)
	elseif haystack.head == needle
		haystack.head = replacement
	end
	for i = 1:length(haystack.args)
		if typeof(haystack.args[i]) == Expr
			replacesymbol!(haystack.args[i], needle, replacement)
		elseif haystack.args[i] == needle
			haystack.args[i] = replacement
		end
	end
	return haystack
end

function in(needle, haystack::Expr)
	if needle == haystack.head
		return true
	elseif typeof(haystack.head) == Expr
		if in(needle, haystack.head)
			return true
		end
	end
	for i = 1:length(haystack.args)
		if needle == haystack.args[i]
			return true
		elseif typeof(haystack.args[i]) == Expr
			if in(needle, haystack.args[i])
				return true
			end
		end
	end
	return false
end

end
