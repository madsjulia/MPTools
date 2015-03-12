module Metatools

function replacesymbolwithvalue!(haystack::Expr, needle::Symbol, value)
	if typeof(haystack.head) == Expr
		replacesymbolwithvalue!(haystack.head, needle, value)
	elseif haystack.head == needle
		haystack.head = value
	end
	for i = 1:length(haystack.args)
		if typeof(haystack.args[i]) == Expr
			replacesymbolwithvalue!(haystack.args[i], needle, value)
		elseif haystack.args[i] == needle
			haystack.args[i] = value
		end
	end
	return haystack
end

end
