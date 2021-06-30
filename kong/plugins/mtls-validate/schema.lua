local typedefs = require "kong.db.schema.typedefs"


return {
  name = "mtls-validate",
  fields = {
    {
      -- this plugin will only be applied to Services or Routes
      consumer = typedefs.no_consumer
    },
    {
      config = {
        type = "record",
        fields = {
          {
            upstream_cert_header = {
              type = "string",
              required = false,
            },
          },
          {
            upstream_verify_header = {
              type = "string",
              required = false,
            },
          }
        },
      },
    },
  },
  entity_checks = {
    -- Describe your plugin's entity validation rules
  },
}
