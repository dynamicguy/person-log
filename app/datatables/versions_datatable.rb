class VersionsDatatable
  delegate :params, :h, :l, :link_to, :current_user, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Version.count,
        iTotalDisplayRecords: versions.total_entries,
        aaData: data
    }
  end

  private

  def data
    versions.map do |version|
      [
          '<input id="bulk_ids_" name="bulk_ids[]" type="checkbox" value="'+version.id.to_s+'">'.html_safe,
          link_to(version.id, version),
          version.item_type,
          version.event,
          l(version.created_at, :format => :long),
          (link_to('Edit', "/versions/#{version.id}/edit", :class => 'btn btn-mini') + " " +
              link_to('Delete', "/versions/#{version.id}", :method => :delete, :data => {:confirm => 'Are you sure?'}, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def versions
    @versions ||= fetch_versions
  end

  def fetch_versions
    if params[:type]
      versions = Version.where("whodunnit='#{current_user.id}'").order("#{sort_column} #{sort_direction}")
    else
      versions = Version.order("#{sort_column} #{sort_direction}")
    end
    versions = versions.page(page).per_page(per_page)
    if params[:sSearch].present?
      versions = versions.where("item_type like :search", search: "%#{params[:sSearch]}%")
    end
    versions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id id item_type event created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end