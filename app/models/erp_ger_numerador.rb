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

  def self.teste2
    query = 'SELECT CAC_CONTATOE1R1.nextval PROXIMO_NUMERO FROM dual'
    connection.select_all(query)
  end

  def self.retorna_proximo_numero(tabela, numerador)
  	## Devera entrar na tabela GER_NUMERADOR, buscar o campo próximo número da empresa e revenda
  	## relacionada a nota e imediatamente somar +1
  	configuracao      = Configuracao.first
  	ultimo_numero     = 0
    erp_ger_numerador = ErpGerNumerador.where(empresa: configuracao.empresa)
                                   .where(revenda: configuracao.revenda)
  								 							   .where(tabela: tabela)
                                   .where(numerador: numerador)
                                   .order('proximo_numero DESC')
    if erp_ger_numerador.present?
      ultimo_numero = erp_ger_numerador.first.proximo_numero rescue 0
      proximo_numero = ultimo_numero + 1
      sql  = "UPDATE GER_NUMERADOR SET proximo_numero = #{proximo_numero} "
      sql += "WHERE empresa = #{configuracao.empresa} AND revenda = #{configuracao.revenda} AND "
      sql += "tabela = '#{tabela}' AND numerador = '#{numerador}'"
      connection.execute(sql)
    end
    ultimo_numero
  end

end
