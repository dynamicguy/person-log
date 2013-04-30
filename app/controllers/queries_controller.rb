class QueriesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  add_breadcrumb :queries, :queries_path

  # GET /queries
  # GET /queries.json
  def index
    add_breadcrumb :list
    #@queries = Query.select("id, q, ip, ua, created_at").where(:user_id => current_user.id).search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
    #@queries = Query.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: QueriesDatatable.new(view_context) }
    end
  end

  # GET /queries/1
  # GET /queries/1.json
  def show
    add_breadcrumb :details
    @query = Query.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @query }
    end
  end

  # GET /queries/new
  # GET /queries/new.json
  def new
    add_breadcrumb :new
    @query = Query.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @query }
    end
  end

  # GET /queries/1/edit
  def edit
    add_breadcrumb :edit
    @query = Query.find(params[:id])
  end

  # POST /queries
  # POST /queries.json
  def create
    @query = Query.new(params[:query])

    respond_to do |format|
      if @query.save
        format.html { redirect_to @query, notice: 'Query was successfully created.' }
        format.json { render json: @query, status: :created, location: @query }
      else
        format.html { render action: "new" }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /queries/1
  # PUT /queries/1.json
  def update
    @query = Query.find(params[:id])

    respond_to do |format|
      if @query.update_attributes(params[:query])
        format.html { redirect_to @query, notice: 'Query was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /queries/1
  # DELETE /queries/1.json
  def destroy
    @query = Query.find(params[:id])
    @query.destroy

    respond_to do |format|
      format.html { redirect_to queries_url, notice: 'Query was successfully deleted.'  }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Query.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
