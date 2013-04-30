class PersonsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: User.count,
        iTotalDisplayRecords: users.total_entries,
        aaData: data
    }
  end

  private

  def data
    users.map do |user|
      [
          '<input id="bulk_ids_" name="bulk_ids[]" type="checkbox" value="'+user.id.to_s+'">'.html_safe,
          link_to(user.name, user),
          user.gender,
          user.address,
          user.sign_in_count,
          user.created_at.stamp("Jan 1st, 1999 10:30")
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    @search = User.search do
      with :published, true
      fulltext params[:sSearch] do
        fields(:bio, :address, :email, :name => 2.0)
      end
      order_by sort_column, sort_direction
      paginate :page => page, :per_page => per_page
      facet :tag_list
    end
    users = @search.results
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name gender address sign_in_count]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end