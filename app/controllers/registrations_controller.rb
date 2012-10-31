class RegistrationsController < Devise::RegistrationsController

  def new
    build_resource
  end

  def create
    super
    if params[:user][:password].blank?
      # from: http://blog.logeek.fr/2009/7/2/creating-small-unique-tokens-in-ruby
      params[:user][:password] = rand(36**8).to_s(36)
    end
    params[:user][:password_confirmation] = params[:user][:password]
    session[:omniauth] = nil unless @user.new_record?
  end

  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?

    successfully_updated = if email_changed or password_changed
                             @user.update_with_password(params[:user])
                           else
                             @user.update_without_password(params[:user])
                           end

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to @user, :notice => "User updated."
    else
      render "edit"
    end
  end

  private
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth], false)
      @user.valid?
    end
  end
end
