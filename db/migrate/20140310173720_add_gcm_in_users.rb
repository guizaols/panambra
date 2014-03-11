class AddGcmInUsers < ActiveRecord::Migration
  def up
  	add_column :usuarios,:gcm,:string
  end

  def down
  	remove_column  :usuarios,:gcm
  end
end
