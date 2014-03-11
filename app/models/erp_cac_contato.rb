#encoding: UTF-8

class ErpCacContato < ConexaoPanambra 

  ### CONTATO
  self.table_name = 'CAC_CONTATO'

  def self.sqlteste
    query = 'SELECT * FROM cac_contato WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_contato(auditoria, contato_cac_contato)
    configuracao = Configuracao.first
    ErpCacContato.create({
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      contato: contato_cac_contato,
      dta_contato: DateTime.now,
      dta_fechamento: DateTime.now,
      situacao: configuracao.situacao,
      des_contato: configuracao.des_contato,
      ativo_passivo: configuracao.ativo_passivo,
      departamento: configuracao.departamento,
      tipo_contato: configuracao.tipo_contato,
      sub_tipo_contato: configuracao.subtipo_contato,
      usuario_abriu: configuracao.usuario_responsavel,
      usuario_encaminhado_original: configuracao.usuario_responsavel,
      usuario_encaminhado: configuracao.usuario_responsavel,
      cliente: auditoria.cliente.codigo,
      forma_contato: configuracao.forma_contato,
      origem: configuracao.origem
    })
  end

end
