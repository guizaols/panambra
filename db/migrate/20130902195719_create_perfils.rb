class CreatePerfils < ActiveRecord::Migration
  def change
    create_table :perfils do |t|
      t.string :nome
      t.text :permissoes
      t.belongs_to :entidade
      t.integer :situacao

      t.timestamps
    end
    add_index :perfils, :entidade_id
  end
end
