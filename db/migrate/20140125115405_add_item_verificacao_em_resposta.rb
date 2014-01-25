class AddItemVerificacaoEmResposta < ActiveRecord::Migration
  
  def up
  	add_column :respostas, :item_verificacao_id, :integer
  	add_index :respostas, :item_verificacao_id
  	remove_column :respostas, :item_checklist_id
  end

  def down
  	remove_column :respostas, :item_verificacao_id
  	remove_index :respostas, :item_verificacao_id
  	add_column :respostas, :item_checklist_id, :integer
  	add_index :respostas, :item_checklist_id
  end

end
