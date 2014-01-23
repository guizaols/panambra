class CreateItemChecklists < ActiveRecord::Migration
  def change
    create_table :item_checklists do |t|
      t.integer :checklist_id
      t.integer :peso
      t.string :nome
      t.integer :item_checklist_id
      t.integer :situacao
      t.timestamps
    end
  end
end
