class AddUsuarioResponsavelEmConfiguracao < ActiveRecord::Migration
  
  def up
  	add_column :configuracoes, :usuario_responsavel, :integer
  end

  def down
  	remove_column :configuracoes, :usuario_responsavel
  end

end
