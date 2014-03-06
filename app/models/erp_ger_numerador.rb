#encoding: UTF-8

class ErpGerNumerador < ConexaoPanambra 

  self.table_name = 'GER_NUMERADOR'

  def self.sqlteste
    query = 'SELECT * FROM ger_numerador WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
