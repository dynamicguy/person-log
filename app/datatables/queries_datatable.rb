class QueriesDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Query.count,
        iTotalDisplayRecords: queries.total_entries,
        aaData: data
    }
  end

  private

  def data
    queries.map do |query|
      [
          '<input id="bulk_ids_" name="bulk_ids[]" type="checkbox" value="'+query.id.to_s+'">'.html_safe,
          link_to(query.ip, query),
          query.q,
          h([UserAgent.parse(query.ua).browser, UserAgent.parse(query.ua).os].join(' - ')),
          query.created_at.stamp("Jan 1st, 1999"),
          (link_to('Edit', "/queries/#{query.id}/edit", :class => 'btn btn-mini') + " " +
              link_to('Delete', "/queries/#{query.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def queries
    @queries ||= fetch_queries
  end

  def fetch_queries
    queries = Query.order("#{sort_column} #{sort_direction}")
    queries = queries.page(page).per_page(per_page)
    if params[:sSearch].present?
      queries = queries.where("q like :search or ua like :search", search: "%#{params[:sSearch]}%")
    end
    queries
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id q ip ua created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end