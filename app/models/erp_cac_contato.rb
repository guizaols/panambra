#encoding: UTF-8

class ErpCacContato < ConexaoPanambra 

  ### CONTATO
  self.table_name = 'CAC_CONTATO'

  attr_accessible :empresa
  attr_accessible :revenda
  attr_accessible :contato
  attr_accessible :dta_contato
  attr_accessible :dta_fechamento
  attr_accessible :situacao
  attr_accessible :des_contato
  attr_accessible :ativo_passivo
  attr_accessible :departamento
  attr_accessible :tipo_contato
  attr_accessible :sub_tipo_contato
  attr_accessible :usuario_abriu
  attr_accessible :usuario_encaminhado_original
  attr_accessible :usuario_encaminhado
  attr_accessible :cliente
  attr_accessible :forma_contato
  attr_accessible :origem


  def self.sqlteste
    query = 'SELECT * FROM cac_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_contato(auditoria, contato_cac_contato,conf)
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
	
	#configuracao = Configuracao.first
	
	
	begin
    cliente = auditoria.cliente.codigo
    ErpCacContato.create({
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      contato: contato_cac_contato,
      dta_contato: (DateTime.now - 3.hours),
      situacao: configuracao.situacao,
      des_contato: configuracao.des_contato,
      ativo_passivo: configuracao.ativo_passivo,
      departamento: configuracao.departamento,
      tipo_contato: configuracao.tipo_contato,
      sub_tipo_contato: configuracao.subtipo_contato,
      usuario_abriu: configuracao.usuario_responsavel,
      usuario_encaminhado_original: configuracao.usuario_responsavel,
      usuario_encaminhado: configuracao.usuario_responsavel,
      cliente: cliente,
      forma_contato: configuracao.forma_contato,
      origem: configuracao.origem
    })
	rescue Exception => e
	
	my_logger = Logger.new("#{Rails.root}/log/errooooo.log")
		my_logger.info("#{e.message.to_s}")
	end
  end

end
