#encoding: UTF-8

class ErpCacSubtipoContato < ConexaoPanambra 

  ### SUB TIPO CONTATO
  self.table_name = 'CAC_SUB_TIPO_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_subtipo_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.retorna_for_select
    ErpCacSubtipoContato.order(:sub_tipo_contato)
    								    .map {|forma| [("#{forma.sub_tipo_contato} - #{forma.des_sub_tipo_contato}"), forma.sub_tipo_contato] }
                        .uniq
  end

end
