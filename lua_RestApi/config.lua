local config = require("lapis.config")

config("development", {
  port = 8080,
  mysql = {
    host = "127.0.0.1",
    user = "mysql",
    password = "root",
    database = "12345"
  }
})