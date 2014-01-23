class CreateAcaos < ActiveRecord::Migration
  def change
    create_table :acoes do |t|
      t.integer :tipo
      t.text :destinatarios
      t.integer :item_verificacao_id
      t.integer :alternativa_id

      t.timestamps
    end
  end
end
