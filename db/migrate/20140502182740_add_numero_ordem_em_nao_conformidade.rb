class AddNumeroOrdemEmNaoConformidade < ActiveRecord::Migration
  
  def up
  	add_column :nao_conformidades, :numero_ordem, :string
  end

  def down
  	remove_column :nao_conformidades, :numero_ordem
  end

end
