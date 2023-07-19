--- Register action
-- @module action.register

return {
	before = function(self)
	end,

	GET = function(self)
		return { render = "register" }
	end
}
