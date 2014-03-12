#encoding: UTF-8

class ErpGerNumerador < ConexaoPanambra 

  ### NUMERADOR
  self.table_name = 'GER_NUMERADOR'

  def self.sqlteste
    query = 'SELECT * FROM ger_numerador WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
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
      update = erp_ger_numerador.first
      update.proximo_numero = proximo_numero
      update.save
    end
    ultimo_numero
  end

end
