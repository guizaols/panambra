class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :cpf_cnpj
      t.string :codigo
      t.string :nome
      t.references :unidade

      t.timestamps
    end
    add_index :clientes, :unidade_id
    add_index :auditorias, :cliente_id
  end
end
