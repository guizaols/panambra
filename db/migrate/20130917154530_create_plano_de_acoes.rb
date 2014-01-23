class CreatePlanoDeAcoes < ActiveRecord::Migration
  def change
    create_table :plano_de_acoes do |t|
      t.string :nome
      t.date :data_abertura
      t.integer :situacao
      t.integer :ponto_de_venda_id
      t.integer :responsavel_id

      t.timestamps
    end
  end
end
