#encoding: UTF-8

class ErpCacTipoContato < ConexaoPanambra 

  ### TIPO CONTATO
  self.table_name = 'CAC_TIPO_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_tipo_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.retorna_for_select
    ErpCacTipoContato.order(:tipo_contato)
    								 .map {|forma| [("#{forma.tipo_contato} - #{forma.des_tipo_contato}"), forma.tipo_contato] }
                     .uniq
  end

end
