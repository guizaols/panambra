#encoding: UTF-8

class ErpFatFrenteCaixa < ConexaoPanambra 

  ### FRNTE DE CAIXA
  self.table_name = 'FAT_FRENTE_CAIXA'

  def self.sqlteste
    query = 'SELECT * FROM fat_frente_caixa WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
