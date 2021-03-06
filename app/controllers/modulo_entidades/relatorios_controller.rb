#encoding: UTF-8

class ModuloEntidades::RelatoriosController < ApplicationController

	before_filter :valid_payment
	

	def pesquisas_respondidas
		params[:pesquisa] ||= {}
		@auditorias = Relatorio.pesquisas_respondidas(current_unidade.id, params[:pesquisa])
		@numero_de_conformidades = 0
		@numero_de_nao_conformidades = 0
		@auditorias.each do |auditoria|
			@numero_de_nao_conformidades += NaoConformidade.where("auditoria_id = ?",auditoria.id).length
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
		@media_geral = 0
		@nota = 0
		@auditorias.each do |auditoria|
			auditoria.respostas.each do |resposta|
				 @nota += resposta.resposta_verbose.to_i
			end
		end
		@media_geral =(@nota / @auditorias.length.to_f).round(2)
	end

	def relatorio_ordem_servicos
		params[:pesquisa] ||={}
		@checklist = Checklist.find params[:pesquisa][:checklist_id] rescue nil
		@data_inicial = params[:pesquisa][:data_inicial].to_date rescue nil
		@data_final = params[:pesquisa][:data_final].to_date rescue nil
		@unidade_id = params[:pesquisa][:unidade_id] #rescue nil
		@numero_de_ordens = nil
		@numero_de_ordens_gerada_no_erp = nil
		@ordens_geradas_no_erp = nil
		@ids = []
		if !@checklist.blank? && !@data_inicial.blank? && !@data_final.blank? && !@unidade_id.blank?
		     mylogger ||= Logger.new("#{Rails.root}/log/logs_sql22.log")
			 @objeto_ordens =Auditoria.where("(DATE(created_at) BETWEEN ? AND ?) AND checklist_id = ? AND situacao = ? AND numero_ordem IS NOT NULL AND unidade_id = ?",@data_inicial,@data_final,@checklist.id,Auditoria::RESPONDIDA,@unidade_id).select("DISTINCT(auditorias.numero_ordem)")
		    @numero_de_ordens = @objeto_ordens.length
			
			mylogger.info("Conteudo da variabel:#{@objeto_ordens}")
			
			@ordens_geradas_no_erp = ErpOfiAtendimento.count_number_numero_de_ordens_de_servico(@data_inicial,@data_final,"#{request.remote_ip}",@unidade_id)		  
			
			@ordens_geradas_no_erp.each do |ordem|
				
				@ids << ordem["nro_os"]
			end
	        
			@numero_de_ordens_gerada_no_erp = @ids.length
			
			@retorno = []
			(@data_inicial..@data_final).each do |dat|
			   temp = {}
			   temp["data"] ||= dat.to_date.strftime("%d/%m/%Y")
			   @temp_ordens_geradas_no_erp = ErpOfiAtendimento.count_number_numero_de_ordens_de_servico(temp["data"],temp["data"],"#{request.remote_ip}",@unidade_id)		  
			   @ordens_sistema = Auditoria.where("(DATE(created_at) BETWEEN ? AND ?) AND checklist_id = ? AND situacao = ? AND numero_ordem IS NOT NULL AND unidade_id = ?",dat,dat,@checklist.id,Auditoria::RESPONDIDA,@unidade_id)
			   @temp_numero_de_ordens = @ordens_sistema.length
			   temp["num_audit"] ||= @temp_numero_de_ordens
			   temp["num_os_erp"] ||= @temp_ordens_geradas_no_erp.length
			   temp["oss"] ||= ""
			   temp["oss_sistema"] ||= @ordens_sistema.collect(&:numero_ordem).join(",")
			   @vetor_ordens_erp = []
			   @temp_ordens_geradas_no_erp.each do |obj|
			    @vetor_ordens_erp << obj["nro_os"].to_s
			   end
			   temp["oss"] = (@vetor_ordens_erp - @ordens_sistema.collect(&:numero_ordem)).join(",")
			   @retorno << temp
			   mylogger.info("Conteudo da variabel:#{temp}")
			   mylogger.info("Vetor erp da variabel:#{@vetor_ordens_erp}")
			   mylogger.info("Vetor sistema:#{@ordens_sistema.collect(&:numero_ordem)}")
			   mylogger.info("Final: #{(@vetor_ordens_erp - @ordens_sistema.collect(&:numero_ordem))}")
			end
			
			
			

    else
    end		  

	end

end
