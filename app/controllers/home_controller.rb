class HomeController < ApplicationController

  def index
    drop_breadcrumb('index')
    @users = User.all
  end
end
