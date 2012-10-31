class SessionsController < Devise::SessionsController
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication
      flash.now[:notice] = t(:signed_in)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash.now[:notice] = t(:success)
      redirect_to authentications_url
    elsif omniauth['provider'] != 'twitter' && omniauth['provider'] != 'linked_in'
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash.now[:notice] = t(:welcome)
      sign_in_and_redirect(:user, user)
    elsif (omniauth['provider'] == 'twitter' || omniauth['provider'] == 'linked_in') &&
        omniauth['uid'] && (omniauth['user_info']['name'] || omniauth['user_info']['nickname'] ||
        (omniauth['user_info']['first_name'] && omniauth['user_info']['last_name']))
      session[:omniauth] = omniauth

      if session[:omniauth]
        user = User.new
        user.name = session[:omniauth]['user_info']['first_name'] + ' ' + session[:omniauth]['user_info']['last_name']
        user.email = 'random_' + session[:omniauth]['user_info']['first_name'].to_s.downcase + '' + session[:omniauth]['user_info']['last_name'].to_s.downcase + user.id.to_s + '_linkedin@' + 'soclose.by'
        user.password, user.password_confirmation = String::RandomString(16)
        user.apply_omniauth(session[:omniauth], true)

        if user.save
          if session[:omniauth]["extra"]
            user.authentications.create!(:info => session[:omniauth]['user_info'].to_json, :provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'], :token => session[:omniauth]["extra"]["access_token"].token, :secret => session[:omniauth]["extra"]["access_token"].secret)
          else
            user.authentications.create!(:info => session[:omniauth]['user_info'].to_json, :provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'])
          end
          session[:omniauth] = nil
          flash.now[:notice] = t(:welcome)
          sign_in_and_redirect(:user, user)
        else
          flash.now[:alert] = user.errors.to_a[0]
          return redirect_to new_user_registration_url
        end
      end
    else
      # New user data not valid, try again
      flash.now[:alert] = t(:fail)
      redirect_to new_user_registration_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end