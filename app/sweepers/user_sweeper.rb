class UserSweeper < ActionController::Caching::Sweeper
  observe User # This sweeper is going to keep an eye on the User model

  # If our sweeper detects that a User was created call this
  def after_create(sweeper)
    expire_cache_for(sweeper)
  end

  # If our sweeper detects that a Product was updated call this
  def after_update(sweeper)
    expire_cache_for(sweeper)
  end

  # If our sweeper detects that a Product was deleted call this
  def after_destroy(sweeper)
    expire_cache_for(sweeper)
  end

  private
  def expire_cache_for(sweeper)
    expire_page(:controller => 'users', :action => 'index')
  end
end