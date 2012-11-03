class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:update, :destroy]

  # GET /persons/search
  # GET /persons/search.json
  # GET /persons/search.xml
  def search
    @start = Time.now
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


  # GET /persons/typeahead
  # GET /persons/typeahead.json
  # GET /persons/typeahead.xml
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

  # GET /persons
  # GET /persons.json
  # GET /persons.xml
  def index
    @start = Time.now
    drop_breadcrumb('Users')
    authorize! :index, @user, :message => 'You are not authorized to perform this operation.'
    if params[:tag]
      users = User.tagged_with(params[:tag]).order(:name).page params[:page]
      @search = User.search do
        with(:email, users.collect { |u| u.email })
        order_by :updated_at, :desc
        paginate :page => params[:page], :per_page => 20
      end
    else
      @search = User.search do
        fulltext params[:q]
        order_by :updated_at, :desc
        paginate :page => params[:page], :per_page => 20
      end
    end
  end


  # GET /persons/1
  # GET /persons/1.json
  # GET /persons/1.xml
  def show
    drop_breadcrumb("Users", users_path)
    drop_breadcrumb('show')
    @user = User.find(params[:id])
  end


  # PUT /persons/1
  # PUT /persons/1.json
  def update
    authorize! :update, @user, :message => 'You are not authorized to perform this operation.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  # DELETE /persons/1
  # DELETE /persons/1.json
  def destroy
    authorize! :destroy, @user, :message => 'You are not authorized to perform this operation.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  # GET /persons/new
  # GET /persons/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /persons/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /persons
  # POST /persons.json
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