#encoding: UTF-8

class ErpOfiAtendimento < ConexaoPanambra 

  ### OFICINA ATENDIMENTO
  self.table_name = 'OFI_ATENDIMENTO'

  def self.sqlteste
    query = 'SELECT * FROM oa.cliente_emissao_nf
             FROM ofi_atendimento oa, ofi_ordem_servico os
             WHERE oa.empresa = os.empresa AND
                   oa.revenda = os.revenda AND
                   oa.contato = os.contato AND
                   rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
