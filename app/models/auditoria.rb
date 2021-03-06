#encoding: UTF-8

class Auditoria < ActiveRecord::Base
  
	### SITUAÇÃO
	PENDENTE   = 63524
  LIBERADA 	 = 19326
	RESPONDIDA = 98743

  ### STATUS BOTÕES DA VIEW
  SIM        = 12659
  NAO        = 85465
  ESPONTANEA = 77462

  attr_accessible :cliente_id
  attr_accessible :numero_nf
  attr_accessible :situacao
  attr_accessible :numero_ordem

  belongs_to :cliente
	belongs_to :unidade
	belongs_to :checklist

  has_many :respostas, order: 'id ASC', dependent: :destroy

	validates :cliente, presence: true
  validates :unidade, presence: true
	validates :checklist, presence: true

	scope :by_unidade_id, lambda { |unidade_id| where(unidade_id: unidade_id) }


  def initialize(attributes = {})
  	attributes['situacao'] ||= LIBERADA
  	super
  end

  def situacao_verbose
  	case situacao
    when PENDENTE; 'Pendente'
  	when LIBERADA; 'Liberada'
  	when RESPONDIDA; 'Respondida'
  	end
  end

  def self.pesquisa(unidade_id, params)
    auditorias = Auditoria.by_unidade_id(unidade_id)
    auditorias = auditorias.where('created_at >= ?', params[:data_inicial].to_date) if params[:data_inicial].present?
    auditorias = auditorias.where('created_at <= ?', params[:data_final].to_date) if params[:data_final].present?
    auditorias = auditorias.order('created_at DESC')
  end

  def carrega_itens_checklist
  	self.checklist
  			.item_checklists
  			.where('item_checklist_id IS NOT NULL')
  			.order(:id)
  end

  def self.cria_nova_auditoria(ordem,conf)
    current_unidade = Unidade.first
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 current_unidade = Unidade.first
	elsif conf == "192.168.170.89"
	 current_unidade = Unidade.find 2
	elsif conf == "211.0.144.90"
	 current_unidade = Unidade.find 3
	elsif conf == "192.168.130.90"
	 current_unidade = Unidade.find 4 
	elsif conf == "211.0.137.90"
	  current_unidade = Unidade.find 5
	end
	
	
	numero_ord = ordem
    ordem = ErpOfiAtendimento.find_by_ordem_servico(ordem,conf)
    if ordem.present?
      cli_erp = ErpFatCliente.find_by_cliente(ordem.first['cliente_emissao_nf'])
      cliente = Cliente.find_by_codigo(cli_erp.cliente.to_s) rescue nil
      # cliente = Cliente.first
      if cli_erp.present? && cliente.blank?
        cliente = Cliente.new({
          codigo: (cli_erp.cliente rescue nil),
          nome: (cli_erp.nome.strip rescue nil),
          cpf_cnpj: (cli_erp.cpf_cnpj.strip rescue nil),
          unidade_id: current_unidade.id
        })
        cliente.save
      end
      auditoria = Auditoria.new
      auditoria.cliente   = cliente
      auditoria.unidade   = current_unidade
     # auditoria.checklist = current_unidade.retorna_checklist_ativo
	  auditoria.checklist = Unidade.first.retorna_checklist_ativo
      auditoria.numero_ordem = numero_ord 
	  
      if auditoria.save!
        [true, auditoria]
      else
        [false, 'Problemas na hora de criar a auditoria!']
      end
    else
      [false, 'Não foi possível localizar essa Ordem de Serviço!']
    end
  end

  def salvar_respostas(params,conf = "localhost")
    begin
      Resposta.transaction do
      	possui_respostas_validas = false
        if params['respostas'].present?
        	Resposta.delete_all("auditoria_id = #{self.id}")
          params['respostas'].each do |item_verificacao_id, resposta|
            item_verificacao = ItemVerificacao.find(item_verificacao_id) rescue nil
            if item_verificacao.present?
            	### START RESPOSTAS
              new_resp = Resposta.new
              new_resp.auditoria = self
              new_resp.item_verificacao = item_verificacao
              if resposta.present?
	              if item_verificacao.tipo == ItemVerificacao::TEXTO
                  possui_respostas_validas = true
	                new_resp.resposta_texto = resposta.strip
	                new_resp.save!
	              else
	                resposta.each do |opcao, resp|
                    if resp.present?
                      possui_respostas_validas = true
                      alternativa = Alternativa.find(opcao) rescue nil
                      if alternativa.present?
                        if alternativa.titulo == 'Sim'
                          new_resp.resposta = Resposta::SIM
                        elsif alternativa.titulo == 'Não'
                          new_resp.resposta = Resposta::NAO
                        else
                          new_resp.resposta = alternativa.id
                        end
      	                # new_resp.resposta = (alternativa.titulo == 'Sim' ? Resposta::SIM : Resposta::NAO)

                        if item_verificacao.tipo == ItemVerificacao::SIM_NAO_TEXTO
                          new_resp.resposta_texto = params['respostas_opcoes'][item_verificacao.id.to_s]
                        end
                        new_resp.save!
                      end
                    end
                  end
	              end
            	end
            	### END RESPOSTAS
            end
          end

          if possui_respostas_validas
            self.update_column(:situacao, RESPONDIDA)

            ### INTEGRAÇÃO COM O ERP
              contato_cac_contato = ErpGerNumerador.retorna_proximo_numero('CAC_CONTATO', 'CONTATO',conf)
              contato_cac_contato = ErpGerNumerador.retorna_proximo_numero_contato(conf)
              ErpCacContato.salva_cac_contato(self, contato_cac_contato,conf)
              ErpCacProvidencia.salva_cac_providencia(contato_cac_contato,conf)
              cac_resposta = ErpCacResposta.salva_cac_resposta(self, contato_cac_contato,conf)
			  	my_logger ||= Logger.new("#{Rails.root}/log/fuichamado.log")
		my_logger.info("Contato: #{contato_cac_contato}")
		my_logger.info("Passei aqui")
              self.respostas.each do |res|
                ErpCacRespostaItem.salva_cac_resposta_item(cac_resposta.resposta, res.item_verificacao.de_para, res,conf)
              end
            ### INTEGRAÇÃO COM O ERP

            ### ENVIO DE NOTIFICAÇÕES (APP / E-MAIL)
            self.notifica_responsaveis_do_checklist(params[:ordem],conf)
            ### ENVIO DE NOTIFICAÇÕES (APP / E-MAIL)

          	[true, 'Pesquisa finalizada com sucesso. Muito obrigado pela sua atenção!']
          else
        		[false, 'Por favor, preencha a pesquisa!']
        	end
        end
      end
    rescue Exception => e
    	p e.message
      p e.backtrace
      [false, e.message]
    end
  end

  def self.retorna_auditoria_para_ser_respondida(conf)
	current_unidade = Unidade.first
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 current_unidade = Unidade.first
	elsif conf == "192.168.170.89"
	 current_unidade = Unidade.find 2
	elsif conf == "211.0.144.90"
	 current_unidade = Unidade.find 3
	elsif conf == "192.168.130.90"
	 current_unidade = Unidade.find 4 
	elsif conf == "211.0.137.90"
	  current_unidade = Unidade.find 5
	end
    auditorias = Auditoria.where("situacao = ? AND unidade_id = ?",LIBERADA,current_unidade.id)
    if auditorias.present?
      [true, auditorias.first]
    else
      [false, 'Sem pesquisas no momento. Aguardando alguma liberação!']
    end
  end

  def numero_de_nao_conformidades
    nao_conformidade = 0
    self.respostas.each do |resposta|
      if resposta.item_verificacao.tipo < 3
        if resposta.resposta == Resposta::NAO
          nao_conformidade += 1
        end
      end
    end
    nao_conformidade
  end

  def numero_de_conformidades
    conformidade = 0
    self.respostas.each do |resposta|
      if resposta.item_verificacao.tipo < 3
        if resposta.resposta == Resposta::SIM
          conformidade += 1
        end
      end
    end
    conformidade
  end

  def notifica_responsaveis_do_checklist(numero_ordem,conf)
    begin
	  current_unidade = Unidade.first
	  current_usuario = Usuario.first
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 current_unidade = Unidade.first
	 current_usuario = Usuario.find 14
	elsif conf == "192.168.170.89"
	 current_unidade = Unidade.find 2
	 current_usuario = Usuario.find 17
	elsif conf == "211.0.144.90"
	 current_unidade = Unidade.find 3
	 current_usuario = Usuario.find 18
	elsif conf == "192.168.130.90"
	 current_unidade = Unidade.find 4 
	 current_usuario = Usuario.find 19
	elsif conf == "211.0.137.90"
	  current_unidade = Unidade.find 5
	  current_usuario = Usuario.find 20
	  
	  end
      retorno ||= {}
      self.respostas.each do |resposta|
        if resposta.resposta.present?
         sim_ou_nao = nil #(resposta.resposta == Resposta::SIM ? 'SIM' : 'NÃO')
         if resposta.resposta == Resposta::SIM
          sim_ou_nao = 'SIM'
         elsif resposta.resposta == Resposta::NAO
          sim_ou_nao = 'NÃO'
         else
          sim_ou_nao = Alternativa.find(resposta.resposta).titulo.upcase
         end
          acoes = resposta.item_verificacao.acoes.joins(:alternativa)
                          .where('UPPER(alternativas.titulo) = ?', sim_ou_nao)
          acoes.each do |acao|
          #  emails = acao.usuarios.pluck(:email).compact.uniq
			emails = [current_usuario.email]
            if emails.present?
              emails.each do |email|
                retorno[email] ||= []
                retorno[email] << resposta
              end
            end
          end
        else
          acoes = resposta.item_verificacao
                          .acoes
                          .where(item_verificacao_id: resposta.item_verificacao_id)
          acoes.each do |acao|
            #emails = acao.usuarios.pluck(:email).compact.uniq
			emails = [current_usuario.email]
            if emails.present?
              emails.each do |email|
                retorno[email] ||= []
                retorno[email] << resposta
              end
            end
          end
        end
      end

      retorno.each do |email, respostas|
        usu = Usuario.where(email: email, unidade_id: current_unidade.id).first
        respostas.each do |resposta|
          nao_conf                     = NaoConformidade.new
          nao_conf.status              = NaoConformidade::CRIADO
          nao_conf.data                = Date.today
          nao_conf.usuario_id          =  current_usuario.id
          nao_conf.cliente_id          = self.cliente_id
          nao_conf.auditoria_id        = self.id
          nao_conf.resposta            = resposta.resposta_verbose rescue nil
          nao_conf.item_verificacao_id = resposta.item_verificacao_id
          nao_conf.unidade_id          = current_unidade.id
          nao_conf.numero_ordem        = numero_ordem
          nao_conf.save!
          Gcm.send_android_message(usu.gcm)
        end
        # AuditoriaMailer.envia_notificacao_para_responsaveis(email, respostas).deliver
      end
    rescue Exception => e
      p e.message
      p e.backtrace
    end
  end

end
