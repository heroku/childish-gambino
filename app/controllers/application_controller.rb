class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Basic

  http_basic_authenticate_with name: ENV.fetch("SLUG"), password: ENV.fetch("PASSWORD")

  # def authenticate
  #   #binding.pry
  #   authenticate_with_http_basic do |username, password|
  #     ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("SLUG"), username) &
  #     ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("PASSWORD"), password)
  #   end
  # end
end
