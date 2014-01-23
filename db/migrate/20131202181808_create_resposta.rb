class CreateResposta < ActiveRecord::Migration
  def change
    create_table :resposta do |t|
      t.integer :item_verificacao_id
      t.integer :agenda_id
      t.string :resposta
      t.string :resposta_texto
      t.timestamps
    end
  end
end
