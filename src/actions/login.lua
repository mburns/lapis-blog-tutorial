-- local csrf = require("lapis.csrf")

-- local capture_errors = require("lapis.application").capture_errors

-- local app = lapis.Application()

-- app:get("form", "/form", function(self)
--     local csrf_token = csrf.generate_token(self)
--     self:html(function()
--         form({ method = "POST", action = self:url_for("form") }, function()
--         input({ type = "hidden", name = "csrf_token", value = csrf_token })
--         input({ type = "submit" })
--         end)
--     end)
-- end)

-- app:post("form", "/form", capture_errors(function(self)
--     csrf.assert_token(self)
--     return "The form is valid!"
-- end))


--- Domain action
-- @module action.domain

return {
	before = function(self)
	end,

	GET = function(self)
		return { render = "login" }
	end
}
