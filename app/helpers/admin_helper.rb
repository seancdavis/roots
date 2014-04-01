module AdminHelper

  # --------------------------------- Inflectors

  def model_plural
    @model.to_s.tableize.humanize.titleize
  end

  def model_singular
    model_plural.singularize
  end

  def model_table
    @model.to_s.tableize
  end

  def model_table_singular
    model_table.singularize
  end

  # --------------------------------- Routes

  def set_routes
    @routes = {
      :index => send("admin_#{model_table}_path"),
      :new => send("new_admin_#{model_table_singular}_path")
    }
    unless params[:id].nil?
      @item = @model.find_by_id(params[:id])
      @item = @model.find_by_slug(params[:id]) if @item.nil?
      @routes.merge!(
        :show => send("admin_#{model_table_singular}_path", @item),
        :edit => send("edit_admin_#{model_table_singular}_path", @item)
      )
    end
  end

  # --------------------------------- Forms

  def form_page(options = {})
    render :partial => 'admin/shared/forms/form_page', :locals => options
  end

  def form_section(title, &block)
    render :partial => 'admin/shared/forms/form_section', :locals => {
      :title => title, :content => capture(&block) }
  end

  def form_column(title, side = 'left', &block)
    side ||= 'left'
    render :partial => "admin/shared/forms/form_column_#{side}", :locals => {
      :title => title, :content => capture(&block) }
  end

  def wysiwyg(form)
    render :partial => 'admin/shared/forms/editor', :locals => { :f => form }
  end

  def publishable_fields(form)
    render :partial => 'admin/shared/forms/publishable', :locals => { :f => form }
  end

  def wysihtml5_icon(cmd,icon = cmd,options = {})
    options[:cmd] = "data-wysihtml5-command-value='#{options[:cmd]}'" unless options[:cmd] == ''
    "<a data-wysihtml5-command='#{cmd}' #{options[:cmd]} id='#{options[:id]}' 
      class='#{options[:class]}'>
      <i class='icon-#{icon}'></i>
    </a>".html_safe
  end

  def wysihtml5_link(cmd,val=cmd,options={})
    options[:cmd] = "data-wysihtml5-command-value='#{options[:cmd]}'" unless options[:cmd] == ''
    "<a data-wysihtml5-command='#{cmd}' #{options[:cmd]} id='#{options[:id]}' class='#{options[:class]}'>
      #{val}
    </a>".html_safe
  end

  def form_eligible?(attribute)
    if attribute == 'id' || attribute == 'created_at' || attribute == 'updated_at'
      return false
    end
    true
  end

  # --------------------------------- Time

  def months
    [
      ['January', 1],
      ['February', 2],
      ['March', 3],
      ['April', 4],
      ['May', 5],
      ['June', 6],
      ['July', 7],
      ['August', 8],
      ['September', 9],
      ['October', 10],
      ['November', 11],
      ['December', 12],
    ]
  end

  def years
    years = []
    5.times do |idx|
      years << (Date.today.year - idx).to_i
    end
    years
  end

  # --------------------------------- Misc

  def icon_to(icon, path, options = {})
    link_to path, :class => options[:class] do
      "<i class='icon-#{icon}'></i>".html_safe
    end
  end

end
