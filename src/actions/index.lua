--- Index action
-- @module action.index

return {
	before = function(self)
	end,

	GET = function(self)
		return { render = "index" }
	end
}
