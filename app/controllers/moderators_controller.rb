class ModeratorsController < ApplicationController
  before_filter :authenticate_user!

  def dashboard
    add_breadcrumb :dashboard
    authorize! :update, User, :message => 'You are not authorized to perform this operation.'
    respond_to do |format|
      format.html # dashboard.html.erb
      format.json { render json: ModeratorsDatatable.new(view_context) }
    end
  end

  def versions
    authorize! :update, User, :message => 'You are not authorized to perform this operation.'
    @versions = Version.where("whodunnit = ?", current_user.id.to_s).page(params[:page]).per(5)
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

end
