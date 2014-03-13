class AddClienteEspontaneoEmConfiguracao < ActiveRecord::Migration

  def up
  	add_column :configuracoes, :cliente_espontaneo, :integer
  end

  def down
  	remove_column :configuracoes, :cliente_espontaneo
  end

end
