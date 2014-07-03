#encoding: UTF-8

class ErpGerNumerador < ConexaoPanambra 

  ### NUMERADOR
  self.table_name = 'GER_NUMERADOR'

  def self.sqlteste
    query = 'SELECT * FROM ger_numerador WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.teste1
    query = "SELECT sequence_name FROM USER_SEQUENCES WHERE sequence_name = 'CAC_CONTATOE1R1'"
    connection.select_all(query)
  end

  def self.retorna_proximo_numero_contato(conf)
	configuracao = nil
	query = 'SELECT CAC_CONTATOE1R1.nextval PROXIMO_NUMERO FROM dual'
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 query = 'SELECT CAC_CONTATOE1R1.nextval PROXIMO_NUMERO FROM dual'
	elsif conf == "192.168.170.89"
	 query = 'SELECT CAC_CONTATOE1R8.nextval PROXIMO_NUMERO FROM dual'
	elsif conf == "211.0.144.90"
	  query = 'SELECT CAC_CONTATOE1R4.nextval PROXIMO_NUMERO FROM dual'
	elsif conf == "192.168.130.90"
	   query = 'SELECT CAC_CONTATOE1R3.nextval PROXIMO_NUMERO FROM dual'
	elsif conf == "211.0.137.90"
	  query = 'SELECT CAC_CONTATOE1R6.nextval PROXIMO_NUMERO FROM dual'
	end
    
    resultado = connection.select_all(query)
    (resultado.first['proximo_numero'].to_i - 1) rescue 1
  end

  def self.retorna_proximo_numero(tabela, numerador,conf)
  	## Devera entrar na tabela GER_NUMERADOR, buscar o campo próximo número da empresa e revenda
  	## relacionada a nota e imediatamente somar +1
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
  	ultimo_numero     = 0
    #erp_ger_numerador = ErpGerNumerador.where(empresa: configuracao.empresa)
     #                                  .where(revenda: configuracao.revenda)
  		#						 							       .where(tabela: tabela)
         #                              .where(numerador: numerador)
          #                             .order('proximo_numero DESC')
	erp_ger_numerador = ErpGerNumerador.where(tabela: tabela)
                                       .where(numerador: numerador)
                                       .order('proximo_numero DESC')
    if erp_ger_numerador.present?
      ultimo_numero = erp_ger_numerador.first.proximo_numero rescue 0
      proximo_numero = ultimo_numero + 1
      sql  = "UPDATE GER_NUMERADOR SET proximo_numero = #{proximo_numero} "
      sql += "WHERE "
      sql += "tabela = '#{tabela}' AND numerador = '#{numerador}'"
      connection.execute(sql)
    end
    ultimo_numero
  end

end
