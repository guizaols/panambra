#encoding: UTF-8

class Administracao::AdministradoresController < ApplicationController
	
	before_filter :verifica_se_o_usuario_eh_administrador_do_sistema

	def index
		params[:pesquisa] ||= {}
		unless params[:pesquisa][:texto].blank?
		 	@administradores = Usuario.pesquisa_administradores(params[:pesquisa])
		 														.page(params[:page]).per(15)
		else
			@administradores = Usuario.where(tipo: Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA)
																.order(:nome).page(params[:page]).per(15)
		end
	end

	def show
		@administrador = Usuario.find params[:id]
	end

	def new
		@administrador = Administrador.new
	end

	def create
		@administrador = Administrador.new(params[:administrador])
		@administrador.tipo = Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA
		if @administrador.save
			redirect_to [:administracao, @administrador], notice: 'Usuário criado com sucesso!'
		else
			render :new
		end
	end

	def edit
		@administrador = Administrador.find(params[:id])
	end

	def update
		@administrador = Administrador.find(params[:id])
		if @administrador.update_attributes(params[:administrador])
			redirect_to [:administracao, @administrador], notice: 'Usuário atualizado com sucesso!'
		else
			render :edit
		end
	end

	def change_status
		@administrador = Usuario.find(params[:id])
		if @administrador.situacao == Usuario::ATIVO
			@administrador.situacao = Usuario::INATIVO
		else
			@administrador.situacao = Usuario::ATIVO
		end
		if @administrador.save
			redirect_to [:administracao, :administradores], notice: 'Situação alterada com sucesso!'
		else
			redirect_to [:administracao, :administradores], notice: 'Não foi possível alterar a situação do registro!'
		end
	end

end
