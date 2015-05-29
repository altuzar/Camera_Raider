ActiveAdmin.register Camera do
  permit_params :sucursal, :numcamera, :nombre, :ipaddress, :user, :pass, :tags, :status
  menu :priority => 5

  index do
    column :sucursal
    column :nombre
    column :ipaddress
    column :user
    column :tags
    actions
  end

  filter :sucursal
  filter :nombre
  filter :tags

  form do |f|
    f.inputs "Camara" do
      f.input :sucursal
      f.input :numcamera
      f.input :nombre
      f.input :ipaddress
      f.input :user
      f.input :pass
      f.input :tags
      f.input :status
    end
    f.actions
  end

  show do
    attributes_table do
      row :sucursal
      row :numcamera
      row :nombre
      row :ipaddress
      row :user
      row :pass
      row :tags
      row :status
    end
  end

end
