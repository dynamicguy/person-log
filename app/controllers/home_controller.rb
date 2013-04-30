class HomeController < ApplicationController
  skip_authorization_check
  caches_action :index

  def index
    @users = User.all
  end
end
