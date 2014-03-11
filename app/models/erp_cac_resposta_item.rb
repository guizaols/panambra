#encoding: UTF-8

class ErpCacRespostaItem < ConexaoPanambra 

  ### ITEM DE RESPOSTA
  self.table_name = 'CAC_RESPOSTA_ITEM'

  def self.sqlteste
    query = 'SELECT * FROM cac_resposta_item WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta_item(cac_resposta, questao_de_para, resposta_pesquisa)
    configuracao = Configuracao.first
    resposta = configuracao.sim if resposta_pesquisa == Resposta::SIM
    resposta = configuracao.nao if resposta_pesquisa == Resposta::NAO
    ErpCacRespostaItem.create({
      resposta: cac_resposta,
      empresa: configuracao.empresa,
      questao: questao_de_para,
      escolha: resposta
    })
  end

end
