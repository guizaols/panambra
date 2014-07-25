#encoding: UTF-8

class ErpOfiAtendimento < ConexaoPanambra 

  ### OFICINA ATENDIMENTO
  self.table_name = 'OFI_ATENDIMENTO'

  def self.sqlteste
    query = 'SELECT *
             FROM ofi_atendimento oa, ofi_ordem_servico os
             WHERE oa.empresa = os.empresa AND
                   oa.revenda = os.revenda AND
                   oa.contato = os.contato AND
                   rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.find_by_ordem_servico(numero_os,conf = "localhost")
    #configuracao = Configuracao.first
    configuracao = nil
	revenda_id = nil
	mylogger ||= Logger.new("#{Rails.root}/log/logs_sq38217423748912789472139l22.log")
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 configuracao = Configuracao.first
	elsif conf == "192.168.170.89"
	 configuracao = Configuracao.find 2
	elsif conf == "211.0.144.90"
	 configuracao = Configuracao.find 3
	 mylogger.info("Entrei no dois novamente")
	 mylogger.info("#{configuracao.revenda}")
	 mylogger.info("#{configuracao.empresa}")
	elsif conf == "192.168.130.90"
	 configuracao = Configuracao.find 4
    elsif conf == "211.0.137.90"
	  configuracao =Configuracao.find 5	 
	end
	
    query = "SELECT *
             FROM ofi_atendimento oa, ofi_ordem_servico os
             WHERE oa.empresa = os.empresa AND
                   oa.revenda = os.revenda AND
                   oa.contato = os.contato AND
				   oa.empresa = #{configuracao.empresa} AND
                   oa.revenda = #{configuracao.revenda} AND
                   nro_os = #{numero_os}"
	         mylogger.info("#{query}")
    connection.select_all(query)
  end

  def self.count_number_numero_de_ordens_de_servico(data_inicial, data_final,conf,unidade_id)
   begin
    #configuracao = Configuracao.first
	configuracao = nil
	unidade_Id = unidade_id.to_s
	revend_id = nil
	#configuracao = Configuracao.first
	if  unidade_id == "1"
 	 configuracao = Configuracao.first
	 
	elsif  unidade_id == "2"
	 configuracao = Configuracao.find 2 
	elsif  unidade_id == "3"
	 configuracao = Configuracao.find 3 
	elsif  unidade_id == "4"
	 configuracao = Configuracao.find 4  
	elsif  unidade_id == "5"
	  configuracao =Configuracao.find 5
	end
	revenda_id = configuracao.revenda
	data_inicial_formatada = data_inicial.to_date.strftime("%Y-%m-%d")
	data_final_formatada = data_final.to_date.strftime("%Y-%m-%d")
   # query = "SELECT *
    #         FROM ofi_atendimento oa, ofi_ordem_servico os
     #        WHERE oa.empresa = os.empresa AND
      #             oa.revenda = os.revenda AND
       #            oa.contato = os.contato AND
        #           oa.empresa = #{configuracao.empresa} AND
         #          oa.revenda = #{configuracao.revenda} AND
          #         oa.categoria_os = 1 AND
           #        (oa.dta_encerramento BETWEEN #{data_inicial} AND #{data_final})"
    query = "select distinct os.nro_os, fmc.dta_entrada_saida,os.revenda from ofi_ordem_servico os, ofi_atendimento oa , fat_movimento_capa fmc
			where
			os.empresa=oa.empresa AND
			os.revenda=oa.revenda AND
			os.contato=oa.contato AND
			os.empresa=fmc.empresa AND
			os.revenda=fmc.revenda AND
			os.contato=fmc.contato AND
			os.categoria_os='1' AND
			oa.empresa = #{configuracao.empresa} AND		
			oa.revenda = #{configuracao.revenda} AND
			fmc.departamento in('7','8') AND
			fmc.tipo_transacao='O21' AND
			fmc.dta_entrada_saida between '#{data_inicial_formatada}' and '#{data_final_formatada}'
			order by os.nro_os"
		#
#    
			#
        #    
				
	query_1 = "select os.nro_os, fmc.dta_entrada_saida,os.revenda from ofi_ordem_servico os, ofi_atendimento oa , 	fat_movimento_capa fmc
where
os.empresa=oa.empresa AND
os.revenda=oa.revenda AND
os.contato=oa.contato AND
os.empresa=fmc.empresa AND
os.revenda=fmc.revenda AND
os.contato=fmc.contato AND
os.categoria_os =1 AND
fmc.departamento in(7,8) AND
fmc.tipo_transacao='O21' AND

fmc.dta_entrada_saida between TO_DATE('#{data_inicial_formatada}','dd/mm/yyyy') and TO_DATE('#{data_final_formatada}','dd/mm/yyyy')
and os.revenda='#{revenda_id}'
order by os.nro_os"
				    mylogger = Logger.new("#{Rails.root}/log/logs_sql8888888.log")
	  mylogger.info("#{query}")

    connection.select_all(query)
	
	rescue Exception=>e
	  mylogger = Logger.new("#{Rails.root}/log/logs_sql.log")
	  mylogger.info("#{e.message}")
	  mylogger.info(e.backtrace.join("\n"))
	end
  end

end
