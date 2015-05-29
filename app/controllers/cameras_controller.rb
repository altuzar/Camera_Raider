class CamerasController < InheritedResources::Base

  def index
  	@cameras = Camera.order(:sucursal)
  end

end
