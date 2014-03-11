#encoding: UTF-8

class ModuloEntidades::AuditoriasController < ApplicationController

	before_filter :valid_payment
	before_filter :verifica_se_esta_logado, except: [:edit, :update]
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade, except: [:edit, :update]


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
		@auditoria.unidade = current_unidade
		@auditoria.checklist = current_unidade.retorna_checklist_ativo

		erp_cliente = ErpFatCliente.where(cliente: codigo_cliente)
		params[:cliente] = { codigo: codigo_cliente, nome: erp_cliente.nome, cpf_cnpj: nil }

p params[:cliente]

		# @auditoria.cliente = Cliente.cria_ou_recupera(current_unidade.id, params[:cliente])
		if @auditoria.save
			redirect_to [:entidade, :auditorias], notice: 'Auditoria liberada com sucesso!'
		else
			render :new
		end
	end

	def edit
		@auditoria = Auditoria.find(params[:id])
		render :layout=>"auditoria_inicial"
	end

	def update
		@auditoria = Auditoria.find(params[:id])
		@retorno = @auditoria.salvar_respostas(params)
	end

	def iniciar_pesquisa
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida
	end

	def retorna_clientes
    configuracao = Configuracao.first
    @clientes 	 = []
    @clientes_ids = ErpFatFrenteCaixa.where(revenda: configuracao.revenda)
    														 		 .where(situacao: 'P')
    														 		 .where(caixa: [3])
    														 		 .where(origem: configuracao.origem)
    														 		 .limit(10)
    														 		 .pluck(:cliente_emissao_nf)
    														 		 .uniq
    @clientes = ErpFatCliente.where(cliente: @clientes_ids).order(:nome) rescue nil if @clientes_ids.present?
    # @clientes = Cliente.all
  end

end
