class AddAuditoriaToRespostas < ActiveRecord::Migration
  
  def up
  	add_column :respostas, :auditoria_id, :integer
  	add_index :respostas, :auditoria_id
  end

  def down
  	remove_column :respostas, :auditoria_id
  	remove_index :respostas, :auditoria_id
  end

end
