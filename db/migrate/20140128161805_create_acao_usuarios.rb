class CreateAcaoUsuarios < ActiveRecord::Migration
  def change
    create_table :acao_usuarios do |t|
      t.references :acao
      t.references :usuario

      t.timestamps
    end
    add_index :acao_usuarios, :acao_id
    add_index :acao_usuarios, :usuario_id
  end
end
