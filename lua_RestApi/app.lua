local lapis = require("lapis")
local config = require("lapis.config").get()
local respond_to = require("lapis.application").respond_to
local json_params = require("lapis.application").json_params
local Model = require("lapis.db.model").Model
local app = lapis.Application()

local Products = Model:extend("products", {
  primary_key = "id"
})

local Categories = Model:extend("categories", {
  primary_key = "id"
})

app:match("/", function(self)
  return config.greeting .. " from port " .. config.port
end)

app:match("/category", respond_to({
  before = function(self)
  end,
  GET = function(self)
    if self.params.id then
      local category = Categories:find(self.params.id)
      return {
        json = {
          category
        }
      }
    end
    local categories = Categories:select("")
    return {
      json = {
        categories
      }
    }  
  end,
  POST = function(self)
    if self.params.name and self.params.id then
      local category = Categories:find(self.params.id)
      category:update({
        name = self.params.name
      })
      return {
        json = {
          "Updated"
        }
      }
    end
    if self.params.name then
      local category = Categories:create({
        name = self.params.name
      })
      return {
        json = {
          category
        }
      }
    end
    return {
      json = {
        "Invalid params"
      }
    }
  end,
  DELETE = function(self)
    if self.params.id then
      local category = Categories:find(self.params.id)
      category:delete()
      return {
        json = {
          "Deletion successful"
        }
      }
    end
    return {
      json = {
        "No id provided"
      }
    }
  end
}))

app:match("/product", respond_to({
  before = function(self)
    if self.session.current_user then
    end
  end,
  GET = function(self)
    if self.params.id then
      local product = Products:find(self.params.id)
      return {
        json = {
          product
        }
      }
    end
    local products = Products:select("")
    return {
      json = {
        products
      }
    }  
  end,
  POST = function(self)
    if self.params.name and self.params.id and self.params.categoryId then
      local product = Products:find(self.params.id)
      product:update({
        name = self.params.name,
        category_id = self.params.categoryId
      })
      return {json = {
        "Updated"
      }
    }
    end
    if self.params.name and self.params.categoryId then
      local product = Products:create({
        name = self.params.name,
        category_id = self.params.categoryId
      })
      return {
        json = {
          product
        }
      }
    end
    return {
      json = {
        "Invalid params"
      }
    }
  end,
  DELETE = function(self)
    if self.params.id then
      local product = Products:find(self.params.id)
      product:delete()
      return {
        json = {
          "Deletion successful"
        }
      }
    end
    return {
      json = {
        "No id provided"
      }
    }
  end
}))

return app