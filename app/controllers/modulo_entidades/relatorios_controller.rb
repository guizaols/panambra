#encoding: UTF-8

class ModuloEntidades::RelatoriosController < ApplicationController

	before_filter :valid_payment
	

	def pesquisas_respondidas
		params[:pesquisa] ||= {}
		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
		@numero_de_conformidades = 0
		@numero_de_nao_conformidades = 0
		@auditorias.each do |auditoria|
			@numero_de_conformidades += auditoria.numero_de_conformidades
			@numero_de_nao_conformidades += auditoria.numero_de_nao_conformidades
		end
	end

	def relatorio_acoes
		params[:pesquisa] ||= {}
	end

	def dashboards
		params[:pesquisa] ||= {}
		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
		@numero_de_conformidades = 0
		@numero_de_nao_conformidades = 0
		@auditorias.each do |auditoria|
			@numero_de_conformidades += auditoria.numero_de_conformidades
			@numero_de_nao_conformidades += auditoria.numero_de_nao_conformidades
		end
		@auditorias_agrupadas = nil

	end

	def pesquisas_detalhadas
		params[:pesquisa] ||= {}
		@checklist = Checklist.find params[:pesquisa][:checklist_id] rescue nil
		@data_inicial = params[:pesquisa][:data_inicial] rescue nil
		@data_final = params[:pesquisa][:data_final] rescue nil

		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
		@numero_de_conformidades = 0
		@numero_de_nao_conformidades = 0
		@auditorias.each do |auditoria|
			@numero_de_conformidades += auditoria.numero_de_conformidades
			@numero_de_nao_conformidades += auditoria.numero_de_nao_conformidades
		end
	end

end
