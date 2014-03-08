#encoding: UTF-8

class Auditoria < ActiveRecord::Base
  
	### SITUAÇÃO
	PENDENTE   = 63524
  LIBERADA 	 = 19326
	RESPONDIDA = 98743

  attr_accessible :cliente_id
  attr_accessible :numero_nf
  attr_accessible :situacao

  belongs_to :cliente
	belongs_to :unidade
	belongs_to :checklist

  has_many :respostas, order: 'id ASC'

	validates :cliente, presence: true
  validates :unidade, presence: true
	validates :checklist, presence: true

	scope :by_unidade_id, lambda { |unidade_id| where(unidade_id: unidade_id) }


  def initialize(attributes = {})
  	attributes['situacao'] ||= PENDENTE
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

  def salvar_respostas(params)
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
      	                #new_resp.resposta = (alternativa.titulo == 'Sim' ? Resposta::SIM : Resposta::NAO)

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
            ### ENVIO DE NOTIFICAÇÕES (E-MAIL)
            self.notifica_responsaveis_do_checklist
            ### ENVIO DE NOTIFICAÇÕES (E-MAIL)

          	[true, 'Pesquisa finalizada com sucesso. Muito obrigado pela sua atenção!']
          else
        		[false, 'Por favor, preencha a pesquisa!']
        	end
        end
      end
    rescue Exception => e
    	# p e.message
      [false, e.message]
    end
  end

  def self.retorna_auditoria_para_ser_respondida
    auditorias = Auditoria.where(situacao: LIBERADA)
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

  def notifica_responsaveis_do_checklist
    begin
      retorno ||= {}
      self.respostas.each do |resposta|



        if resposta.resposta.present?
         sim_ou_nao = nil #(resposta.resposta == Resposta::SIM ? 'SIM' : 'NÃO')
         if resposta.resposta == Resposta::SIM
          sim_ou_nao = "SIM"
         elsif resposta.resposta == Resposta::NAO
          sim_ou_nao = "NÃO"
         else
          sim_ou_nao = Alternativa.find(resposta.resposta).titulo.upcase
         end
          acoes = resposta.item_verificacao.acoes.joins(:alternativa)
                          .where('UPPER(alternativas.titulo) = ?', sim_ou_nao)
          acoes.each do |acao|
            emails = acao.usuarios.pluck(:email).compact.uniq
            if emails.present?
              emails.each do |email|
                retorno[email] ||= []
                retorno[email] << resposta
              end
            end
          end
        else
          acoes = resposta.item_verificacao.acoes
                          .where(item_verificacao_id: resposta.item_verificacao_id)
          acoes.each do |acao|
            emails = acao.usuarios.pluck(:email).compact.uniq
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
        usu = Usuario.where("email = ? AND unidade_id = ?",email,self.unidade_id).first
        respostas.each do |r|
          nao_conformidade = NaoConformidade.new 
          nao_conformidade.status = NaoConformidade::CRIADO
          nao_conformidade.data = Date.today
          nao_conformidade.usuario_id = usu.id
          nao_conformidade.cliente_id = self.cliente_id
          nao_conformidade.auditoria_id = self.id
          nao_conformidade.item_verificacao_id = r.item_verificacao_id
          nao_conformidade.unidade_id = self.unidade_id
          nao_conformidade.save
        end
        AuditoriaMailer.envia_notificacao_para_responsaveis(email, respostas).deliver
      end




    rescue Exception => e
      p e.message
      p e.backtrace
    end
  end

end
