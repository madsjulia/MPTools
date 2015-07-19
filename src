module MPTools

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
