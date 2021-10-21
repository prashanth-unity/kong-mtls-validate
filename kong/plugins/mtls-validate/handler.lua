local BasePlugin = require("kong.plugins.base_plugin")
local set_header = kong.service.request.set_header

-- utils
local function is_empty(s)
    return s == nil or s == ''
end

local ValidateMtls = BasePlugin:extend()

ValidateMtls.VERSION = "0.2.0"
ValidateMtls.PRIORITY = 810

function ValidateMtls:new()
    ValidateMtls.super.new(self, "mtls-validate")
end

function ValidateMtls:access(config)
    ValidateMtls.super.access(self)

    if ngx.var.ssl_client_verify ~= "SUCCESS" then
        kong.response.exit(config.error_response_code, [[{"error":"invalid_request", "error_description": "mTLS client not provided or invalid"}]], {
            ["Content-Type"] = "application/json"
        })
    end

    if not is_empty(config.upstream_cert_header) then
        set_header(config.upstream_cert_header, ngx.var.ssl_client_escaped_cert)
    end

    if not is_empty(config.upstream_verify_header) then
        set_header(config.upstream_verify_header, ngx.var.ssl_client_verify)
    end

end

return ValidateMtls
