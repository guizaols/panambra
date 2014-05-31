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

  def self.find_by_ordem_servico(numero_os)
    configuracao = Configuracao.first
    query = "SELECT *
             FROM ofi_atendimento oa, ofi_ordem_servico os
             WHERE oa.empresa = os.empresa AND
                   oa.revenda = os.revenda AND
                   oa.contato = os.contato AND
                   oa.empresa = #{configuracao.empresa} AND
                   oa.revenda = #{configuracao.revenda} AND
                   nro_os = #{numero_os}"
    connection.select_all(query)
  end

  def self.count_number_numero_de_ordens_de_servico(data_inicial, data_final)
   begin
    configuracao = Configuracao.first
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
			fmc.departamento in('7','8') AND
			fmc.tipo_transacao='O21' AND
		    oa.empresa = #{configuracao.empresa} AND
            oa.revenda = #{configuracao.revenda} AND
			fmc.dta_entrada_saida between '01/05/2014' and '31/05/2014'
			order by os.nro_os"
				   
    connection.select_all(query)
	
	rescue Exception=>e
	  mylogger = Logger.new("#{Rails.root}/log/logs_sql.log")
	  mylogger.info("#{e.message}")
	  mylogger.info(e.backtrace.join("\n"))
	end
  end

end
