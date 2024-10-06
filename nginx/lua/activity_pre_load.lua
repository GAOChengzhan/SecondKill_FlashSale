-- activity pre load

-- share memory zone, used to save activity data
local activity = ngx.shared.activity

-- get product id from URL
local product_id = ngx.var.arg_productId
if not product_id then
    ngx.say("{\"code\":\"200001\",\"message\":\"productId is null!\"}")
    return
end

-- send request to backend Web service via upstream
local res = ngx.location.capture("/activity/subQuery",{ args = { productId = product_id }})

if not res or res.status ~=200 then
    ngx.say("{\"code\":\"200001\",\"message\":\"activity is null!\"}")
    return
end

-- cache activity data to local, expire time is 10 minutes
activity:set("activity_"..product_id,res.body,10*60)

ngx.say("{\"code\":\"200\",\"message\":\"success\"}")
return