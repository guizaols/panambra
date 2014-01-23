class AdicionaCampoComentariosDataFinalizacaoEmItemPlanoDeAcao < ActiveRecord::Migration
  def up
  	add_column :item_plano_de_acoes, :comentarios, :text
  	add_column :item_plano_de_acoes, :data_finalizacao, :date
  end

  def down
  	remove_column :item_plano_de_acoes, :comentarios
  	remove_column :item_plano_de_acoes, :data_finalizacao
  end
end
