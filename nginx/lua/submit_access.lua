-- Pre-check functionality for order submission

-- Import blacklist-related cache functionality
local black_cache = require "black_user_cache"

local user_id = ngx.var.user_id

-- Use user_id as the key for tracking
local key = user_id

-- Check if the user is in the blacklist
local flag = black_cache.check(key)
if not flag then
    ngx.log(ngx.ERR, key.." is in the blacklist!")
    return ngx.exit(500)
end

-- Check if the user triggers the blacklist rule
local ff = black_cache.filter(key)
if not ff then
    return ngx.exit(500)
end

-- Check if the 'st' is valid
local _st = ngx.md5(user_id.."3")
if _st ~= ngx.var.st then
    ngx.log(ngx.ERR, user_id.." st is invalid!")
    return ngx.exit(500)
end
