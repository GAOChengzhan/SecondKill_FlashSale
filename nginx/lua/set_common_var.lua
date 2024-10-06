-- Parse and set common variables

-- Get 'st' from the request URL and assign it to variable st
local param_st = ngx.var.arg_st
if not param_st then
    param_st = ""
end
ngx.var.st = param_st

-- Get the product ID from the request URL and assign it to variable product_id
local param_product_id = ngx.var.arg_productId
if not param_product_id then
    param_product_id = ""
end
ngx.var.product_id = param_product_id

-- Get user ID from the cookie and assign it to variable user_id
local user_id = ngx.var.cookie_user_id
if not user_id then
    user_id = ""
end

return user_id