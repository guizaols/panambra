class CreateUnidades < ActiveRecord::Migration
  def change
    create_table :unidades do |t|
      t.string :nome
      t.string :slug
      t.belongs_to :entidade
      t.integer :situacao

      t.timestamps
    end
    add_index :unidades, :entidade_id
  end
end
