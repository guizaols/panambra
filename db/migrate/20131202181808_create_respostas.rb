class CreateRespostas < ActiveRecord::Migration
  def change
    create_table :respostas do |t|
      t.belongs_to :item_checklist
      t.string :resposta
      t.string :resposta_texto
      t.timestamps
    end
    add_index :respostas, :item_checklist_id
  end
end
