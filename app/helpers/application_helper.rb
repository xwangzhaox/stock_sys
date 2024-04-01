module ApplicationHelper
  def show_header_conditions
    (
      ['dashboard', 'keywords'].include?(params['controller']) or 
      (params['controller']=='line_items' and params[:action]=='show') or 
      (params[:controller]=="users" and ['show', 'state_history_by_me', 'my_downloads'].include?(params[:action])) or 
      params[:controller]=='history_by_batches' or
      (params[:controller]=='progresses' and params[:action]=='dashboard')
    )
  end

  def container_fluid_class
    if (params[:controller]=="users" and ['show', 'state_history_by_me', 'my_downloads'].include?(params[:action])) or 
      params[:controller]=='history_by_batches' or
      (params[:controller]=='progresses' and params[:action]=='dashboard')
      return ''
    elsif params[:controller]=="keywords"
      return 'position-relative'
    else
      return 'container-fluid'
    end
  end

  def is_valid_url?(str)
    uri = URI.parse str
    uri.kind_of? URI::HTTP
  rescue URI::InvalidURIError
    false
  end
end
