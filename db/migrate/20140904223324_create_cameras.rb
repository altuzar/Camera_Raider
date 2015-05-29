class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.integer :sucursal
      t.integer :numcamera, default: 0
      t.string :ipaddress
      t.string :user
      t.string :pass
      t.string :tags
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
