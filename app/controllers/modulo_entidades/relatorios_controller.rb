#encoding: UTF-8

class ModuloEntidades::RelatoriosController < ApplicationController

	def pesquisas_respondidas
		params[:pesquisa] ||= {}
		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
	end

	def relatorio_acoes
		params[:pesquisa] ||= {}
	end

end
