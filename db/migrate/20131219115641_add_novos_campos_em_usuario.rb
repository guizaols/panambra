class AddNovosCamposEmUsuario < ActiveRecord::Migration

  def up
  	add_column :usuarios, :ramal, :string
  	add_column :usuarios, :telefone, :string
  	add_column :usuarios, :celular, :string
  end

  def down
  	remove_column :usuarios, :ramal
  	remove_column :usuarios, :telefone
  	remove_column :usuarios, :celular
  end

end
