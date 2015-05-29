json.array!(@cameras) do |camera|
  json.extract! camera, :id, :sucursal, :numcamera, :ipaddress, :user, :pass, :tags, :status
  json.url camera_url(camera, format: :json)
end
