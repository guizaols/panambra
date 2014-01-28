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
              	possui_respostas_validas = true
	              if item_verificacao.tipo == ItemVerificacao::TEXTO
	                new_resp.resposta_texto = resposta.strip
	                new_resp.save!
	              else
	                alternativa = Alternativa.find(resposta) rescue nil
	                new_resp.resposta = (alternativa.titulo == 'Sim' ? Resposta::SIM : Resposta::NAO)
	                if item_verificacao.tipo == ItemVerificacao::SIM_NAO_TEXTO
	                  new_resp.resposta_texto = params['respostas_opcoes'][item_verificacao.id.to_s][alternativa.id.to_s]
	                end
	                new_resp.save!
	              end
            	end
            	### END RESPOSTAS
            end
          end

          self.update_column(:situacao, RESPONDIDA)
          if possui_respostas_validas
            ### ENVIO DE NOTIFICAÇÕES (E-MAIL)
            self.notifica_responsaveis_do_checklist
            ### ENVIO DE NOTIFICAÇÕES (E-MAIL)

          	[true, 'Pesquisa finalizada com sucesso. Muito obrigado pela sua atenção!']
          else
        		[false, 'Preencha a pesquisa, por favor!']
        	end
        end
      end
    rescue Exception => e
    	# p e.message
      [false, e.message]
    end
  end

  def self.retorna_auditoria_para_ser_respondida
    auditoria = Auditoria.where(situacao: LIBERADA)
    if auditoria.present?
      [true, auditoria.first]
    else
      [false, 'Sem pesquisas no momento. Aguardando alguma liberação!']
    end
  end

  def notifica_responsaveis_do_checklist
    begin
      retorno ||= {}
      self.respostas.each do |resposta|
        if resposta.resposta.present?
          sim_ou_nao = (resposta.resposta == Resposta::SIM ? 'SIM' : 'NÃO')
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
        AuditoriaMailer.envia_notificacao_para_responsaveis(email, respostas).deliver
      end
    rescue Exception => e
      p e.message
      p e.backtrace
    end

    # self.checklist.item_checklists.each do |item_checklist|
    #   item_checklist.item_verificacaos.each do |item_verificacao|
    #     item_verificacao.acoes.each do |acao|
    #       if self.respostas.where(item_verificacao_id: acao.item_verificacao_id).present?
    #         p acao.item_verificacao.titulo
    #         p self.respostas.where(item_verificacao_id: acao.item_verificacao_id)
    #         p acao.usuarios.pluck(:email)
    #         p '==================================================================='
    #       end
    #     end
    #   end
    # end
  end

end
