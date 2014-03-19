class AddRespostaToNaoConformidade < ActiveRecord::Migration

	def up
		add_column :nao_conformidades, :resposta, :string
	end

	def down
		remove_column :nao_conformidades, :resposta
	end

end
