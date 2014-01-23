class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :nome
      t.integer :situacao
      t.integer :unidade_id

      t.timestamps
    end
  end
end
