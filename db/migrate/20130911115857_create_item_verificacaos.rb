class CreateItemVerificacaos < ActiveRecord::Migration
  def change
    create_table :item_verificacaos do |t|
      t.integer :tipo
      t.string  :titulo
      t.integer :item_checklist_id
      t.integer :situacao
      t.timestamps
    end
  end
end
