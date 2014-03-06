#encoding: UTF-8

class ErpFormaContato < ConexaoPanambra 

  ### FORMA CONTATO
  self.table_name = 'CAC_FORMA_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_forma_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.retorna_for_select
    ErpFormaContato.order(:name)
    							 .map {|forma| [forma.name, forma.id] }
  end

end
