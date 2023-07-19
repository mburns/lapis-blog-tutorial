--- Users model
-- @module models.users

-- local bcrypt = require "bcrypt"
local config          = require("lapis.config").get()
local db              = require "lapis.db"
local Model           = require("lapis.db.model").Model
-- local token  = config.secret
-- local util = require("lapis.util")
local json            = require("cjson")

-- local Users  = Model:extend("users")
local Users, Users_mt = Model:extend("users", {
	url_params = function(self, req, ...)
		return "user_profile", { id = self.id }, ...
	end,

	constraints = {
		--- Apply constraints when updating/inserting a User row, returns truthy to indicate error
		-- @tparam table self
		-- @tparam table value User data
		-- @treturn string error
		user_name = function(self, value)
			-- TODO : check if value is in reserved names
			-- if db.find("reserved_usernames", { user_name = value }) then
			-- 	return "Username is reserved"
			-- end

			-- check for valid length (2-64]
			if string.len(value) >= 64 then
				return "Username must be less than 64 characters"
			end

			if string.len(value) <= 2 then
				return "Username must be more than 2 characters"
			end
		end,

		user_pass = function(self, value)
			-- enforce password length requirements
			local password_minimum_length = 8
			local password_maximum_length = 64 -- 4096
			if string.len(value) < password_minimum_length then
				return string.format("Password must be at least %s characters", password_minimum_length)
			end
			if string.len(value) > password_maximum_length then
				return string.format("Password must no more than %s characters", password_maximum_length)
			end
		end,

		user_email = function(self, value)
			-- value must contain '@'
			if not string.find(value, "@") then
				return "Email must contain '@'"
			end
		end
	},

	relations = {
		{ "subscriptions", has_many = "Subscriptions" },
		{ "posts",         has_many = "Posts" },
		{ "comments",      has_many = "Comments" },
		{
			"moderates",
			has_many = "Subreddits",
			order = "id desc",
			key = "moderator_id"
		},
		{
			"authored_posts",
			has_many = "Posts",
			-- where = {deleted = false},
			order = "id desc",
			key = "user_id"
		},
		{
			"authored_comments",
			has_many = "Comments",
			-- where = {deleted = false},
			order = "id desc",
			key = "user_id"
		}
	}
})

print("RUNNING MODELS.Users")

--- Create a new user
-- @tparam table params User data
-- @tparam string raw_password Raw password
-- @treturn boolean success
-- @treturn string error
function Users:new(params, raw_password)
	-- Check if username is unique
	do
		local unique, err = self:is_unique(params.user_name)
		if not unique then return nil, err end
	end

	-- TODO: Verify password


	local user = Users:create(params)
	return user and user or nil, { "err_create_user", { params.username } }
end

--- Modify a user
-- @tparam table params User data
-- @tparam string raw_username Raw username
-- @tparam string raw_password Raw password
-- @treturn boolean success
-- @treturn string error
function Users:modify(params, raw_username, raw_password)
	db.modify("users", params, { username = raw_username })

	-- TODO: password?
end

--- Delete user
-- @tparam table username User data
-- @treturn boolean success
-- @treturn string error
function Users:delete(username)
	local user = self:get(username)
	if not user then
		return nil, "FIXME"
	end

	-- tomebstone user
	local success = user:update("users",
		{ deleted_tc = db.format_date() },
		{ username = username })

	return success and user or nil, "FIXME"
end

--- Verify user
-- @tparam table params User data
-- @treturn boolean success
-- @treturn string error
-- function Users:login(params)
-- local user = self:get(params.username)
-- if not user then return nil, { "err_invalid_user" } end

-- local password = user.username .. params.password .. token
-- local verified = bcrypt.verify(password, user.password)

-- return verified and user or nil, { "err_invalid_user" }
-- end

--- Get all users
-- @treturn table users List of users
function Users_mt:get_all_comments(uid)
	-- loop up number of rows in subreddits table
	local res = db.select("count(*) from 'subreddits'")
	local n = res[1]["count(*)"]


	local all_comments = {}

	-- loop over all subreddits
	-- TODO index subreddit_id, post_id, comment_id, user_id
	for i = 1, n do
		local tbl = i .. "_comments"
		local subreddit = db.select("* from 'subreddits' where id=?", i)
		-- local id = subreddit[1].id

		local comments = db.select("* from ? where user_id=?", tbl, uid)
		-- require 'pl.pretty'.dump(comments)

		for k, v in ipairs(comments) do
			all_comments[#all_comments + 1] = v
			-- all_comments[#all_comments + k]['subreddit_id'] = subreddit[1].id
		end
	end
	return all_comments
end

--- Given a User, return their subreddit subscriptions
-- @tparam table user
-- @treturn table subscriptions
function Users.get_subscriptions(user)
	local subscriptions = db.select("* from 'subscriptions' where user_id=?", user.id)
	return subscriptions
end

return Users
