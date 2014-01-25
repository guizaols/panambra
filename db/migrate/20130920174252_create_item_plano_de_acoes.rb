class CreateItemPlanoDeAcoes < ActiveRecord::Migration
  def change
    create_table :item_plano_de_acoes do |t|
      t.integer :status
      t.integer :plano_de_acao_id

      t.timestamps
    end
  end
end
