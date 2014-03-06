class AddDeParaEmQuestao < ActiveRecord::Migration
  
  def up
  	add_column :item_verificacaos, :de_para, :integer
  end

  def down
  	remove_column :item_verificacaos, :de_para
  end

end
