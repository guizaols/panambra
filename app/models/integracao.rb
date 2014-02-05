#encoding: UTF-8

class Integracao < ConexaoPanambra 

  self.table_name = 'ger_numerador'

  def self.sqlteste
    query = 'SELECT * FROM ger_numerador WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
