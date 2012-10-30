class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:update, :destroy]

  # GET /users/search
  # GET /users/search.json
  # GET /users/search.xml
  def search
    @search = User.search do
      fulltext params[:q]
      order_by :updated_at, :desc
      paginate :page => params[:page], :per_page => 20
    end

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @search }
      format.xml { render :json => @search }
    end
  end


  # GET /users/typeahead
  # GET /users/typeahead.json
  # GET /users/typeahead.xml
  def typeahead
    @users = User.search do
      fulltext params[:query]
      order_by :updated_at, :desc
      paginate :page => 1, :per_page => 15
    end.results.collect { |u| u.name }
    #raise @users.inspect

    respond_to do |format|
      format.html #typeahead.html.erb
      format.xml { render xml: {:options => @users} }
      format.json { render json: {:options => @users} }
    end
  end

  # GET /users
  # GET /users.json
  # GET /users.xml
  def index
    drop_breadcrumb('Users')
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    if params[:tag]
      @users = User.tagged_with(params[:tag]).order(:name).page params[:page]
    else
      @search = User.search do
        fulltext params[:q]
        order_by :updated_at, :desc
        paginate :page => params[:page], :per_page => 20
      end
    end
  end


  # GET /users/1
  # GET /users/1.json
  # GET /users/1.xml
  def show
    drop_breadcrumb("Users", users_path)
    drop_breadcrumb('show')
    @user = User.find(params[:id])
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    #authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end