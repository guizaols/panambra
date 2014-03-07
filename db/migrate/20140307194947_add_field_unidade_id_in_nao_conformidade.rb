class AddFieldUnidadeIdInNaoConformidade < ActiveRecord::Migration
  def up
  	add_column :nao_conformidades,:unidade_id,:integer
  end

  def down
  	remove_column :nao_conformidades,:unidade_id
  end
end
