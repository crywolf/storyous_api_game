# Production specific configuration
# ==================================
module.exports = {
  # MongoDB connection options
  mongo: {
    uri: process.env.MONGOLAB_URI
  },
}