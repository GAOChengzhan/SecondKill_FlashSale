-- Activity query

-- Shared memory zone, used to save activity data
local activity = ngx.shared.activity

-- Get productId via global variable
local product_id = ngx.var.product_id
if not product_id then
    ngx.say("")
    return
end

-- Query the cache first
local activity_info = activity:get("activity_"..product_id)

if not activity_info or activity_info == "" then
    ngx.log(ngx.ERR, "local activity is null!")

    -- Send request to the backend Web service via upstream
    local res = ngx.location.capture("/activity/subQuery", { args = { productId = product_id }})
    if not res or res.status ~= 200 then
        ngx.say("")
        return
    end

    activity_info = res.body

    -- Cache the activity information locally, expiration time is 10 minutes
    activity:set("activity_"..product_id, activity_info, 10*60)
end

-- Return the activity information
ngx.say(activity_info)
return