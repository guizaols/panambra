#encoding: UTF-8

class ErpCacRespostaItem < ConexaoPanambra 

  ### ITEM DE RESPOSTA
  self.table_name = 'CAC_RESPOSTA_ITEM'

  def self.sqlteste
    query = 'SELECT * FROM cac_resposta_item WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta_item
    configuracao = Configuracao.first
    ErpCacRespostaItem.create({
      resposta: resposta, ## NUMERO DA RESPOSTA
      empresa: configuracao.empresa,
      questao: questao, ## DE-PARA
      escolha: resposta ## RESPOSTA DE CADA QUESTAO
    })
  end

end
