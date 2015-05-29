class Camera < ActiveRecord::Base
	attr_accessible :sucursal, :numcamera, :nombre, :ipaddress, :user, :pass, :tags, :status

end
