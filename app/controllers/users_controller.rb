class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  caches_action [:index, :search, :show, :friends]
  cache_sweeper :user_sweeper
  add_breadcrumb :persons, :users_path


  # GET /persons/search
  # GET /persons/search.json
  # GET /persons/search.xml
  def search
    add_breadcrumb :search
    @start = Time.now
    @search = User.search(:include => [:tags]) do
      fulltext params[:q] do
        fields(:bio, :name => 2.0)
      end
      order_by sort_column, sort_direction
      paginate :page => params[:page], :per_page => 21
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
      fulltext params[:query] do
        fields(:bio, :name => 2.0)
      end
      order_by :id, :desc
      paginate :page => 1, :per_page => 15
    end.results.collect { |u| u.name }

    respond_to do |format|
      format.html #typeahead.html.erb
      format.xml { render :xml => {:options => @users} }
      format.json { render :json => {:options => @users} }
    end
  end

  # GET /persons/manage
  # GET /persons/manage.json
  # GET /persons/manage.xml
  def manage
    add_breadcrumb :manage
    authorize! :manage, @user, :message => 'You are not authorized to perform this operation.'
    respond_to do |format|
      format.html # manage.html.erb
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end


  # GET /persons/map
  # GET /persons/map.json
  # GET /persons/map.xml
  def map
    add_breadcrumb :map
    @map_opt = {
        :zoom => 2,
        :auto_adjust => true,
        :auto_zoom => false,
        :center_on_user => true,
        :detect_location => true
    }
    @users = User.search do
      with :published, true
      fulltext params[:q] do
        fields(:bio, :name => 2.0)
      end
      order_by :id, :desc
    end.results

    @markers = @users.to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(:partial => "/users/marker_template", :locals => {:usr => user})
      marker.json({:id => user.id})
    end
  end

  # GET /persons/list
  # GET /persons/list.json
  # GET /persons/list.xml
  def list
    add_breadcrumb :list
    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: PersonsDatatable.new(view_context) }
    end
  end

  # GET /persons/tags
  # GET /persons/tags.json
  # GET /persons/tags.xml
  def tags
    @tags = User.tag_counts_on(:tags, :conditions => "name LIKE '" + (params[:query] || "") + "%'").limit(50).order('count desc')
    respond_to do |format|
      format.html # tags.html.erb
      format.json { render json: @tags }
      format.xml { render xml: @tags }
    end
  end

  # GET /persons
  # GET /persons.json
  # GET /persons.xml
  def index
    add_breadcrumb :search
    @start = Time.now
    #authorize! :index, @user, :message => 'You are not authorized to perform this operation.'
    Query.create! :q => params[:q], :user_id => current_user.id, :ua => request.env['HTTP_USER_AGENT'], :ip => request.env['REMOTE_ADDR']
    if params[:tag]
      users = User.tagged_with(params[:tag]).order(sort_column + " " + sort_direction).page params[:page]
      @search = users.search(:include => [:tags]) do
        with :published, true
        with :tag_list, params[:tag]
        fulltext params[:q] do
          fields(:bio, :name => 2.0)
        end
        order_by :id, :desc
        paginate :page => params[:page], :per_page => 21
        facet :tag_list
      end
    else
      @search = User.search(:include => [:tags]) do
        with :published, true
        fulltext params[:q] do
          fields(:bio, :name => 2.0)
        end
        order_by sort_column, sort_direction
        paginate :page => params[:page], :per_page => 21
        facet :tag_list
      end
    end
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => :users }
      format.json { render :json => :users }
    end
  end


  # GET /persons/1
  # GET /persons/1.json
  # GET /persons/1.xml
  def show
    add_breadcrumb :details
    @map_opt = {
        :zoom => 2,
        :auto_adjust => true,
        :auto_zoom => false,
        :detect_location => true
    }
    @user = User.find(params[:id], :include => [:positions => [:company]])
    if (current_user.id != @user.id)
      Visit.create! :ip => request.ip, :ua => request.env['HTTP_USER_AGENT'], :user_id => current_user.id, :visitor_id => @user.id
    end
    respond_to do |format|
      format.html do #show.html.erb
        @markers = @user.to_gmaps4rails do |user, marker|
          marker.infowindow render_to_string(:partial => "marker_template", :locals => {:usr => @user})
          marker.json({:id => user.id})
        end
      end
      format.xml { render :xml => {:user => @user} }
      format.json { render :json => {:user => @user} }
    end
  end


  def update_address
    @user = User.find(params[:id])
    @user.address = params[:address]
    @user.save
    respond_to do |format|
      format.js { render :js => "console.log('address of \"#{@user.name}\" has been updated to #{params[:address]}')" }
    end
  end


  # PUT /persons/1
  # PUT /persons/1.json
  def update
    @user = User.find(params[:id])
    authorize! :update, @user, :message => 'You are not authorized to perform this operation.'
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user), :notice => "You updated your account successfully. #{undo_link}"
    else
      redirect_to user_path(@user), :alert => "Unable to update user."
    end
  end

  # DELETE /persons/1
  # DELETE /persons/1.json
  def destroy
    authorize! :destroy, @user, :message => 'You are not authorized to perform this operation.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted. #{undo_link}"
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
      format.json { render :json => @user }
    end
  end

  # GET /persons/1/edit
  def edit
    add_breadcrumb :edit
    @user = User.find(params[:id])
  end

  # POST /persons
  # POST /persons.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => "User was successfully created. #{undo_link}" }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /friends
  # GET friends.json
  # GET friends.xml
  def friends
    @start = Time.now
    @users = current_user.friends.order(:name).page params[:page]

    respond_to do |format|
      format.html # friends.html.erb
      format.json { render :json => @users }
      format.xml { render :xml => @users }
    end
  end

  def invite
    authorize! :invite, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    @user.send_confirmation_instructions
    redirect_to :back, :only_path => true, :notice => "Sent invitation to #{@user.email}."
  end

  def bulk_invite
    authorize! :bulk_invite, @user, :message => 'Not authorized as an administrator.'
    users = User.where(:confirmation_token => nil).order(:created_at).limit(params[:quantity])
    users.each do |user|
      user.send_confirmation_instructions
    end
    redirect_to :back, :only_path => true, :notice => "Sent invitation to #{users.count} users."
  end

  def bulk_action
    authorize! :bulk_invite, @user, :message => 'Not authorized as an administrator.'
    if !params[:bulk_ids]
      redirect_to :back, :only_path => true, :alert => "No user has been selected."
    else
      users = User.find(params[:bulk_ids])
      if 'publish' == params[:bulk_action]
        users.each do |u|
          u.published = true
          u.published_at = Time.now
          u.save
        end
      elsif 'delete' == params[:bulk_action]
        User.destroy(users)
      end
      redirect_to :back, :only_path => true, :notice => "User #{params[:bulk_action]} to #{users.count} users."
    end

  end

  private

  def create_chart
    users_by_day = User.group("DATE(created_at)").count
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date')
    data_table.new_column('number')
    users_by_day.each do |day|
      data_table.add_row([Date.parse(day[0].to_s), day[1]])
    end
    @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table)
  end

  def undo_link
    view_context.link_to("undo", revert_version_path(@user.versions.scoped.last), :method => :post) || ''
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end