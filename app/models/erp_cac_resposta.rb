#encoding: UTF-8

class ErpCacResposta < ConexaoPanambra 

  ### RESPOSTA
  self.table_name = 'CAC_RESPOSTA'

  def self.sqlteste
    query = 'SELECT * FROM cac_resposta WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_resposta(auditoria, contato_cac_contato)
    configuracao = Configuracao.first
    resposta = ErpCacResposta.create({
      resposta: ErpGerNumerador.retorna_proximo_numero('CAC_RESPOSTA', 'RESPOSTA'),
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      questionario: configuracao.questionario,
      cliente: auditoria.cliente.codigo,
      usuario: configuracao.usuario_responsavel,
      dta_resposta: DateTime.now,
      pessoa_contato: auditoria.cliente.nome[0..29],
      contato: contato_cac_contato
    })
    resposta
  end

end
