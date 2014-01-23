class AddUsuarioIdEmItemPlanoAcao < ActiveRecord::Migration
  
  def up
  	add_column :item_plano_de_acoes, :usuario_id, :integer
  	add_index :item_plano_de_acoes, :usuario_id
  end

  def down
  	remove_column :item_plano_de_acoes, :usuario_id
  	remove_index :item_plano_de_acoes, :usuario_id
  end

end
