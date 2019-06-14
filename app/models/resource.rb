class Resource < ApplicationRecord
  attribute :access_token
  attribute :refresh_token

  attr_encrypted :access_token, key: ENV["KEY"]
  attr_encrypted :refresh_token, key: ENV["KEY"]
end
