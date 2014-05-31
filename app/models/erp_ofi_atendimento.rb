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
    query = "SELECT *
             FROM ofi_atendimento oa, ofi_ordem_servico os
             WHERE oa.empresa = os.empresa AND
                   oa.revenda = os.revenda AND
                   oa.contato = os.contato AND
                   oa.empresa = #{configuracao.empresa} AND
                   oa.revenda = #{configuracao.revenda} AND
                   oa.categoria_os = 1 AND
                   (oa.dta_encerramento BETWEEN #{data_inicial} AND #{data_final})"
    connection.select_all(query)
	rescue Exception=>e
	  my_logger ||= Logger.new("#{Rails.root}/log/logs_sql.log")
	  mylogger.info("#{e.message}")
	  mylogger.info(e.backtrace.join("\n"))
	end
  end

end
