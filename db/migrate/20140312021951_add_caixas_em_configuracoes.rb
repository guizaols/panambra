class AddCaixasEmConfiguracoes < ActiveRecord::Migration
  
  def up
  	add_column :configuracoes, :caixas, :string
  end

  def down
  	remove_column :configuracoes, :caixas
  end

end
