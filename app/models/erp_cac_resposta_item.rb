#encoding: UTF-8

class ErpCacRespostaItem < ConexaoPanambra 

  ### ITEM DE RESPOSTA
  self.table_name = 'CAC_RESPOSTA_ITEM'

  attr_accessible :resposta
  attr_accessible :empresa
  attr_accessible :questao
  attr_accessible :escolha


  def self.sqlteste
    query = 'SELECT * FROM cac_resposta_item WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta_item(cac_resposta, questao_de_para, resposta_pesquisa,conf)
    #configuracao = Configuracao.first
	configuracao = nil
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 configuracao = Configuracao.first
	elsif conf == "192.168.170.89"
	 configuracao = Configuracao.find 2
	elsif conf == "211.0.144.90"
	 configuracao = Configuracao.find 3
	elsif conf == "192.168.130.90"
	 configuracao = Configuracao.find 4 
	elsif conf == "211.0.137.90"
	  configuracao =Configuracao.find 5
	end
	
    if resposta_pesquisa.item_verificacao.tipo == ItemVerificacao::ESCALA
      resposta = Alternativa.find(resposta_pesquisa.resposta).titulo
    else
      resposta = configuracao.sim if resposta_pesquisa.resposta == Resposta::SIM
      resposta = configuracao.nao if resposta_pesquisa.resposta == Resposta::NAO
    end
	
	my_logger ||= Logger.new("#{Rails.root}/log/testedelouco.log")
		my_logger.info("resposta: #{cac_resposta}")
		
		my_logger.info("empresa: #{configuracao.empresa}")
		my_logger.info("questao_de_para: #{questao_de_para}")
		my_logger.info("escolha: #{resposta}")
		
	
	
    ErpCacRespostaItem.create({
      resposta: cac_resposta,
      empresa: configuracao.empresa,
      questao: questao_de_para,
      escolha: resposta
    })
  end

end
