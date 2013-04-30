class VisitsDatatable
  delegate :params, :h, :l, :link_to, :current_user, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Visit.count,
        iTotalDisplayRecords: visits.total_entries,
        aaData: data
    }
  end

  private

  def data
    visits.map do |visit|
      [
          '<input id="bulk_ids_" name="bulk_ids[]" type="checkbox" value="'+visit.id.to_s+'">'.html_safe,
          link_to(visit.ip, visit),
          params[:type].present? ? link_to(User.find(visit.visitor_id).name, User.find(visit.visitor_id)) : ((visit.user.present?) ? link_to(visit.user.name, visit) : ''),
          h([UserAgent.parse(visit.ua).browser, UserAgent.parse(visit.ua).os].join(' - ')),
          visit.created.stamp("Jan 1st, 1999 10:20"),
          (link_to('Edit', "/visits/#{visit.id}/edit", :class => 'btn btn-mini') + " " +
              link_to('Delete', "/visits/#{visit.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def visits
    @visits ||= fetch_visits
  end

  def fetch_visits
    if params[:type]
      visits = Visit.where("user_id = #{current_user.id}").order("#{sort_column} #{sort_direction}")
    else
      visits = Visit.where("visitor_id = #{current_user.id}").order("#{sort_column} #{sort_direction}")
    end
    visits = visits.page(page).per_page(per_page)
    if params[:sSearch].present?
      visits = visits.where("ip like :search or ua like :search", search: "%#{params[:sSearch]}%")
    end
    visits
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id ip user ua created]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end