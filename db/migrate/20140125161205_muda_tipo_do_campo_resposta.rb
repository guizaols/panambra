class MudaTipoDoCampoResposta < ActiveRecord::Migration

  def up
    change_column :respostas, :resposta, 'integer USING CAST(resposta AS integer)'
  end

  def down
    change_column :respostas, :resposta, 'varchar USING CAST(resposta AS varchar)'
  end

end
