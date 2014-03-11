#encoding: UTF-8

class ErpCacFormaContato < ConexaoPanambra 

  ### FORMA CONTATO
  self.table_name = 'CAC_FORMA_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_forma_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.retorna_for_select
    configuracao = Configuracao.first
    ErpCacFormaContato.where(empresa: (configuracao.empresa rescue 1))
                      .order(:forma_contato)
    							    .map {|forma| [("#{forma.forma_contato} - #{forma.des_forma_contato}"), forma.forma_contato] }
                      .uniq
  end

end
