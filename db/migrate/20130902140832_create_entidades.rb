class CreateEntidades < ActiveRecord::Migration
  def change
    create_table :entidades do |t|
      t.string :nome
      t.string :slug
      t.integer :situacao
      t.timestamps
    end
  end
end
