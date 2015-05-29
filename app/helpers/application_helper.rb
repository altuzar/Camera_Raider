module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def get_time_ago(s)
    # Esta funcion recibe algo como "/cameras/706/20140120164936.jpg" y lo convierte en x min ago
    ret = "Sin fecha"
    # la_hora = DateTime.parse( s.split("/")[-1].gsub(".jpg","") ) rescue 0
    la_hora = s.split("/")[-1].gsub(".jpg","").to_time rescue 0
    # raise la_hora.inspect
    if la_hora != 0
      # raise la_hora.inspect
      # la_hora = la_hora + 1.hour # (-Time.zone_offset(Time.now.zone))
      # ret = time_ago_in_words( la_hora + (-Time.zone_offset(Time.now.zone)) ) rescue "tiempo"
      ret = time_ago_in_words( la_hora ) rescue "tiempo"
      ret = "Hace #{ret}"
    end
    # raise ret.inspect
    return ret
  end

  def get_exact_time(s)
    # Esta funcion recibe algo como "/cameras/706/20140120164936.jpg" y lo convierte en tiempo
    ret = "Sin fecha"
    la_hora = DateTime.parse( s.split("/")[-1].gsub(".jpg","") ) rescue 0
    if la_hora != 0
        ret = DateTime.parse( s.split("/")[-1].gsub(".jpg","") ).to_s[0..18].gsub("T"," ") rescue "Sin fecha"
        ret = "#{ret}"
    end
    # raise ret.inspect
    return ret
  end

end
