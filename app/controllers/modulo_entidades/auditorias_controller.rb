#encoding: UTF-8

class ModuloEntidades::AuditoriasController < ApplicationController

	before_filter :verifica_se_esta_logado
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade


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
		@auditoria.cliente = Cliente.cria_ou_recupera(current_unidade.id, params[:cliente])
		if @auditoria.save
			redirect_to [:entidade, :auditorias], notice: 'Auditoria liberada com sucesso!'
		else
			render :new
		end
	end

	def edit
		@auditoria = Auditoria.find(params[:id])
	end

	def update
		@auditoria = Auditoria.find(params[:id])
		@retorno = @auditoria.salvar_respostas(params)
	end

	def iniciar_pesquisa
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida
	end

end
