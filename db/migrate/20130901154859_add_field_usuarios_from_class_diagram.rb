class AddFieldUsuariosFromClassDiagram < ActiveRecord::Migration
  def change
  	add_column :usuarios,:nome,:string
  	add_column :usuarios,:login,:string
  	add_column :usuarios,:setor_id,:integer
  	add_column :usuarios,:usuario_superior_id,:integer
  	add_column :usuarios,:perfil_id,:integer
  	add_column :usuarios,:entidade_id,:integer
  	add_column :usuarios,:unidade_id,:integer
  	add_column :usuarios,:situacao,:integer
  	add_column :usuarios,:tipo,:integer
  end
end
