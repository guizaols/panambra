class AddArquivoEmAlternativa < ActiveRecord::Migration
  def up
  	add_column :alternativas,:arquivo,:string
  end

  def down
  	remove_column :alternativas,:arquivo
  end
end
