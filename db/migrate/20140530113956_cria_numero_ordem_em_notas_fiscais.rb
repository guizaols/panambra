class CriaNumeroOrdemEmNotasFiscais < ActiveRecord::Migration
  def up
  	add_column :auditorias,:numero_ordem,:string
  end

  def down
  	remove_column :auditorias,:numero_ordem
  end
end
