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
  	configuracao  = Configuracao.first
  	ultimo_numero = 0
    numerador     = ErpGerNumerador.where(empresa: configuracao.empresa)
                                   .where(revenda: configuracao.revenda)
  								 							   .where(tabela: tabela)
                                   .where(numerador: numerador)
                                   .order('proximo_numero DESC')
    if numerador.present?
      ultimo_numero = numerador.first.proximo_numero rescue 0
      proximo_numero = ultimo_numero + 1
      numerador.first.update_column(proximo_numero: proximo_numero)
    end
    ultimo_numero
  end

end
