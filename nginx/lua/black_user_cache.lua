-- Blacklist cache functionality

local _CACHE = {}
-- Shared memory zone, used to track blacklist and save blacklist data
local hole = ngx.shared.black_hole
-- Request count key prefix
local count_prefix = "co_"
-- Blacklist key prefix
local black_prefix = "bl_"
-- Filter requests, if no blacklist rule is triggered, return true; otherwise return false
function _CACHE.filter(key)
    -- Parameter 1 is the key, parameter 2 is the increment step, parameter 3 is the initial value if the key doesn't exist, parameter 4 is the expiration time for the initial value
    local after_count = hole:incr(count_prefix..key, 1, 0, 1)
    -- If after_count is nil, it means an error occurred, so no blocking is done to prevent false positives
    if not after_count then
       return true
    end
    -- Check the request frequency in 1 second, if it exceeds the threshold, add to the blacklist
    if after_count > 1 then
        ngx.log(ngx.ERR, key.." was caught!!!")
        -- Store in the local cache, expiration time is 15 seconds
        local suc, err = hole:set(black_prefix..key, 1, 15)
        if not suc then
            ngx.log(ngx.ERR, key.." set to cache failed: "..err)
        end
        return false
    end
    return true
end

-- Check if valid, if in the blacklist, return false, otherwise return true
function _CACHE.check(key)
    local value = hole:get(black_prefix..key)
    if not value then
        return true
    end
    return false
end

return _CACHE