class AuthenticationsController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, :only => [:index, :edit, :destroy]
  add_breadcrumb :authentications, :authentications_path

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
    add_breadcrumb :list
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
    @authentication = Authentication.find(params[:id])
    add_breadcrumb :details

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/new
  # GET /authentications/new.json
  def new
    @authentication = Authentication.new
    add_breadcrumb :new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/1/edit
  def edit
    add_breadcrumb :edit
    @authentication = Authentication.find(params[:id])
  end

  # POST /authentications
  # POST /authentications.json
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
    elsif omniauth['provider'] != 'twitter' && omniauth['provider'] != 'linked_in' && user = create_new_omniauth_user(omniauth)
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


  # PUT /authentications/1
  # PUT /authentications/1.json
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
