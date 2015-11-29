path = require 'path'

# All configurations will extend these options
# ============================================
all = {
  env: process.env.NODE_ENV || 'development'

  # Root path of the server
  root: path.normalize(__dirname + '/../..'),

  # Server port
  port: process.env.PORT || 5000,

  # MongoDB connection options
  mongo: {
    options: {
      db: {
        safe: true
      }
    }
  }
}

try
  environmentConfig = require('./' + all.env + '.coffee')
catch error
  throw new Error 'Missing /config/environment/'+ all.env + '.coffee file'

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.extend(
  all,
  environmentConfig || {})