class CreateNaoConformidades < ActiveRecord::Migration
  def change
    create_table :nao_conformidades do |t|
      t.integer :item_verificacao_id
      t.date :data
      t.integer :usuario_id
      t.integer :usuario_delegado_id
      t.integer :cliente_id
      t.integer :status
      t.text :comentarios
      t.date :data_escalonada
      t.integer :auditoria_id

      t.timestamps
    end
  end
end
