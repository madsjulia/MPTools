module Metatools

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

end
