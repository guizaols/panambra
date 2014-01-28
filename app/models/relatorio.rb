#encoding: UTF-8

class Relatorio < ActiveRecord::Base

	def self.pesquisas_respondidas(unidade_id, params)
		Auditoria.all
	end

end
