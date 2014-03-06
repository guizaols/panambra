class CreateConfiguracoes < ActiveRecord::Migration
  def change
    create_table :configuracoes do |t|
      t.integer :empresa
      t.integer :revenda
      t.string  :situacao
      t.text    :des_contato
      t.string  :ativo_passivo
      t.integer :departamento
      t.integer :tipo_contato
      t.integer :subtipo_contato
      t.integer :forma_contato
      t.string  :origem
      t.integer :providencia
      t.string  :tipo_providencia
      t.string  :subtipo_providencia
      t.string  :ativo_passivo
      t.integer :questionario

      t.timestamps
    end
  end
end
