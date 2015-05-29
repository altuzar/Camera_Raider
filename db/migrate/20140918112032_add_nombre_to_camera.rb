class AddNombreToCamera < ActiveRecord::Migration
  def change
    add_column :cameras, :nombre, :string
  end
end
