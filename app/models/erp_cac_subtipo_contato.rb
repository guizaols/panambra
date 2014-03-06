#encoding: UTF-8

class ErpCacSubtipoContato < ConexaoPanambra 

  ### SUB TIPO CONTATO
  self.table_name = 'CAC_SUBTIPO_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_subtipo_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.retorna_for_select
    ErpCacSubtipoContato.order(:name)
    								    .map {|forma| [forma.name, forma.id] }
  end

end
