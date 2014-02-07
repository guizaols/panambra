#encoding: UTF-8

class ModuloEntidades::RelatoriosController < ApplicationController

	def pesquisas_respondidas
		params[:pesquisa] ||= {}
		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
		@numero_de_conformidades = 0
		@numero_de_nao_conformidades = 0
		@auditorias.each do |auditoria|
			p "daiuhsdfiuahsdfuihsdaui 123984723984758934"
			@numero_de_conformidades += auditoria.numero_de_conformidades
			@numero_de_nao_conformidades += auditoria.numero_de_nao_conformidades
		end
		p "siudhfaiusdhfiuasd"
		p @numero_de_conformidades
		p @numero_de_nao_conformidades
	end

	def relatorio_acoes
		params[:pesquisa] ||= {}
	end

end
