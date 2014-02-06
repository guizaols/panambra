#encoding: UTF-8

class ErpCliente < ConexaoPanambra 

  self.table_name = 'FAT_CLIENTE'

  def self.sqlteste
    query = 'SELECT * FROM fat_movimento_capa WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
