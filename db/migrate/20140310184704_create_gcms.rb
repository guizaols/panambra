class CreateGcms < ActiveRecord::Migration
  def change
    create_table :gcms do |t|

      t.timestamps
    end
  end
end
