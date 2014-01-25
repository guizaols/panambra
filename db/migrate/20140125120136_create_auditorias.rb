class CreateAuditorias < ActiveRecord::Migration
  def change
    create_table :auditorias do |t|
      t.integer :cliente_id
      t.references :unidade
      t.references :checklist
      t.string :numero_nf
      t.integer :situacao

      t.timestamps
    end
    add_index :auditorias, :unidade_id
    add_index :auditorias, :checklist_id
  end
end
