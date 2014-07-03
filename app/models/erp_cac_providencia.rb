#encoding: UTF-8

class ErpCacProvidencia < ConexaoPanambra 

  ### PROVIDENCIA
  self.table_name = 'CAC_PROVIDENCIA'

  attr_accessible :empresa
  attr_accessible :revenda
  attr_accessible :contato
  attr_accessible :providencia
  attr_accessible :usuario
  attr_accessible :forma_contato
  attr_accessible :tipo_providencia
  attr_accessible :sub_tipo_providencia
  attr_accessible :dta_providencia
  attr_accessible :des_providencia
  attr_accessible :ativo_passivo
  attr_accessible :usuario_encaminhado


  def self.sqlteste
    query = 'SELECT * FROM cac_providencia WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_providencia(contato_cac_contato,conf)
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
	
    ErpCacProvidencia.create({
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      contato: contato_cac_contato,
      providencia: configuracao.providencia,
      usuario: configuracao.usuario_responsavel,
      forma_contato: configuracao.forma_contato,
      tipo_providencia: configuracao.tipo_providencia,
      sub_tipo_providencia: configuracao.subtipo_providencia,
      dta_providencia: (DateTime.now - 3.hours),
      des_providencia: configuracao.des_contato,
      ativo_passivo: configuracao.ativo_passivo,
      usuario_encaminhado: configuracao.usuario_responsavel
    })
  end

end
