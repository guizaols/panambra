#encoding: UTF-8

class ErpCacProvidencia < ConexaoPanambra 

  ### PROVIDENCIA
  self.table_name = 'CAC_PROVIDENCIA'

  def self.sqlteste
    query = 'SELECT * FROM cac_providencia WHERE rownum <= 10'
    retorno = connection.select_all(query)
    retorno
  end

  def self.salva_cac_previdencia
    configuracao = Configuracao.first
    ErpCacProvidencia.create({
      empresa: configuracao.empresa,
      revenda: configuracao.revenda,
      contato: ErpGerNumerador.retorna_proximo_numero, ## VERIFICAR SE NÃO É PRECISO MUDAR A TABELA
      providencia: configuracao.providencia,
      usuario: configuracao.usuario,
      forma_contato: configuracao.forma_contato,
      tipo_providencia: configuracao.tipo_providencia,
      sub_tipo_providencia: configuracao.subtipo_providencia,
      dta_providencia: Date.today,
      des_providencia: configuracao.des_contato,
      ativo_passivo: configuracao.ativo_passivo,
      usuario_encaminhado: configuracao.usuario_abriu
    })
  end

end
