#encoding: UTF-8

class ModuloEntidades::AuditoriasController < ApplicationController

	before_filter :valid_payment
	before_filter :verifica_se_esta_logado, except: [:edit, :update, :retorna_clientes]
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade, except: [:edit, :update, :retorna_clientes]


	def index
		params[:pesquisa] ||= {}
		@auditorias = Auditoria.pesquisa(current_unidade.id, params[:pesquisa])
													 .page(params[:page])
													 .per(15)
	end

	def show
		@auditoria = Auditoria.find(params[:id])
	end

	def new
		@auditoria = Auditoria.new
	end

	def create
		@auditoria = Auditoria.new
		
		
		conf = request.remote_ip
		acurrent_unidade = Unidade.first
	if conf == "localhost" || conf == "192.168.202.90" || conf == "127.0.0.1"
  	 acurrent_unidade = Unidade.first
	elsif conf == "192.168.170.89"
	 acurrent_unidade = Unidade.find 2
	elsif conf == "211.0.144.90"
	 acurrent_unidade = Unidade.find 3
	elsif conf == "192.168.130.90"
	 acurrent_unidade = Unidade.find 4 
	elsif conf == "211.0.137.90"
	  acurrent_unidade = Unidade.find 5
	end
		
		@auditoria.unidade = acurrent_unidade
		@auditoria.checklist = current_unidade.retorna_checklist_ativo
		
		

		if params[:opcao].to_i == Auditoria::SIM
			erp_cliente = ErpFatCliente.where(cliente: params[:codigo_cliente]).first rescue nil
			if erp_cliente.present?
				params[:cliente] = { codigo: params[:codigo_cliente], nome: erp_cliente.nome, cpf_cnpj: nil }
				@auditoria.cliente = Cliente.cria_ou_recupera_cliente_comum(current_unidade.id, params[:cliente])
			end
		elsif params[:opcao].to_i == Auditoria::ESPONTANEA
			@auditoria.cliente = Cliente.cria_ou_recupera_cliente_espontaneo(current_unidade.id)
		end

		if @auditoria.save
			if current_user.perfil_id.blank?
				redirect_to [:entidade, :auditorias], notice: 'Auditoria liberada com sucesso!'
			else
				redirect_to [:new, :entidade, :auditoria], notice: 'Auditoria liberada com sucesso!'
			end
		else
			render :new
		end
	end

	def edit
		@auditoria = Auditoria.find(params[:id])
		my_logger ||= Logger.new("#{Rails.root}/log/numero_de_ordem273148912378.log")
		my_logger.info("#{request.remote_ip}")
		render layout: 'auditoria_inicial'
		
	end

	def update
		@auditoria = Auditoria.find(params[:id])
		#@retorno 	 = @auditoria.salvar_respostas(params,request.url.split("//").last.split("/").first.split(":").first)
		@retorno 	 = @auditoria.salvar_respostas(params,request.remote_ip)
	end

	def iniciar_pesquisa
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida(request.remote_ip)
		my_logger ||= Logger.new("#{Rails.root}/log/numero_de_ordem.log")
		my_logger.info("#{request.url}")
	end

	def retorna_clientes
    configuracao = Configuracao.first
    @clientes 	 = []
    @clientes_ids = ErpFatFrenteCaixa.where(revenda: configuracao.revenda)
    														 		 .where(situacao: 'P')
    														 		 .where(caixa: configuracao.caixas.split(', '))
    														 		 .where(origem: configuracao.origem)
    														 		 .limit(10)
    														 		 .pluck(:cliente_emissao_nf)
    														 		 .uniq
    @clientes = ErpFatCliente.where(cliente: @clientes_ids).order(:nome) rescue nil if @clientes_ids.present?
    # @clientes = Cliente.where(unidade_id: configuracao.caixas.split(', '))
  end

end
