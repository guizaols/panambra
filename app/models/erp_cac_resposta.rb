#encoding: UTF-8

class ErpCacResposta < ConexaoPanambra 

  ### RESPOSTA
  self.table_name = 'CAC_RESPOSTA'

  attr_accessible :resposta
  attr_accessible :empresa
  attr_accessible :revenda
  attr_accessible :questionario
  attr_accessible :cliente
  attr_accessible :usuario
  attr_accessible :dta_resposta
  attr_accessible :pessoa_contato
  attr_accessible :contato


  def self.sqlteste
    query = 'SELECT * FROM cac_resposta WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta(auditoria, contato_cac_contato,conf)
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
	
			my_logger ||= Logger.new("#{Rails.root}/log/728927438597349573248uhhsdffudf.log")
		my_logger.info("Contato: #{contato_cac_contato}")
		my_logger.info("resposta: #{ErpGerNumerador.retorna_proximo_numero('CAC_RESPOSTA', 'RESPOSTA',conf)}")
		my_logger.info("empresa: #{configuracao.empresa}")
		my_logger.info("revenda: #{configuracao.revenda}")
		my_logger.info("questionario: #{configuracao.questionario}")
		my_logger.info("cliente: #{auditoria.cliente.codigo}")
		my_logger.info("cliente: #{configuracao.usuario_responsavel}")
		my_logger.info("pessoa contato: #{auditoria.cliente.nome[0..29]}")

	
    resposta = ErpCacResposta.create({
      resposta: ErpGerNumerador.retorna_proximo_numero('CAC_RESPOSTA', 'RESPOSTA',conf),
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      questionario: configuracao.questionario,
      cliente: auditoria.cliente.codigo,
      usuario: configuracao.usuario_responsavel,
      dta_resposta: (DateTime.now - 3.hours),
      pessoa_contato: auditoria.cliente.nome[0..29],
      contato: contato_cac_contato
    })
    resposta
  end

end
