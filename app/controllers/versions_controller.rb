class VersionsController < ApplicationController
  before_filter :authenticate_user!
  add_breadcrumb :versions, :versions_path

  def index
    add_breadcrumb :list

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: VersionsDatatable.new(view_context) }
    end
  end

  def show
    add_breadcrumb :details
    @version = Version.find params[:id]
  end

  def revert
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? "undo" : "redo"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
    redirect_to :back, :notice => "Undid #{@version.event}. #{link}"
  end

end