class CreateAcaoResposta < ActiveRecord::Migration
  def change
    create_table :acao_resposta do |t|
      t.integer :resposta_id
      t.integer :item_verificacao_id
      t.text :comentarios
      t.text :file_photo
      t.integer :status
      t.integer :alternativa_id
      t.timestamps
    end
  end
end
