class AddSimENaEmConfiguracao < ActiveRecord::Migration
  
  def up
  	add_column :configuracoes, :sim, :integer
  	add_column :configuracoes, :nao, :integer
  end

  def down
  	remove_column :configuracoes, :sim
  	remove_column :configuracoes, :nao
  end

end
