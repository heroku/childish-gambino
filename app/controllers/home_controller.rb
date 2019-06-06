class HomeController < ApplicationController
  #before_action :authenticate, only: :index
  http_basic_authenticate_with name: ENV.fetch("SLUG"), password: ENV.fetch("PASSWORD"), only: :index

  def index
    render plain: "Hello World!"
  end

  def edit
    render plain: "Only accessible if you have basic auth credentials"
  end
end
