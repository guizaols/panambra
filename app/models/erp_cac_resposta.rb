#encoding: UTF-8

class ErpCacResposta < ConexaoPanambra 

  ### RESPOSTA
  self.table_name = 'CAC_RESPOSTA'

  def self.sqlteste
    query = 'SELECT * FROM cac_resposta WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta(auditoria)
    configuracao = Configuracao.first
    resposta = ErpCacResposta.create({
      resposta: ErpGerNumerador.retorna_proximo_numero, ## VERIFICAR SE NÃO É PRECISO MUDAR A TABELA
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      questionario: configuracao.questionario,
      cliente: auditoria.cliente.codigo,
      # usuario: configuracao.usuario_abriu, ??
      dta_resposta: Date.today,
      pessoa_contato: auditoria.cliente.nome[0..29]
    })
    resposta
  end

end
