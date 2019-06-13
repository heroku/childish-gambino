class Resource < ApplicationRecord
  attr_encrypted :access_token, key: ENV["KEY"]
  attr_encrypted :refresh_token, key: ENV["KEY"]
end
