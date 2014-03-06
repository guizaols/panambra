#encoding: UTF-8

class ErpFatCliente < ConexaoPanambra 

	### CLIENTE
  self.table_name = 'FAT_CLIENTE'

  def self.sqlteste
    query = 'SELECT * FROM fat_cliente WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

end
