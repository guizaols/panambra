#encoding: UTF-8

class ModuloEntidades::UsuariosController < ApplicationController

	before_filter :verifica_se_esta_logado
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade

	def index
		params[:pesquisa] ||= {}
		@usuarios = Usuario.pesquisa(current_unidade.id, params[:pesquisa]).page(params[:page]).per(15)
	end

	def new
		@usuario = Usuario.new
	end

	def create
		@usuario = Usuario.new(params[:usuario])
		@usuario.unidade = current_unidade
		@usuario.entidade = current_unidade.entidade
		if @usuario.save
			redirect_to [:entidade, @usuario], notice: 'Usuário cadastrado com sucesso!'
		else
			render action: :new
		end
	end

	def show
		@usuario = Usuario.find(params[:id])
	end

	def edit
		@usuario = Usuario.find(params[:id])
	end

	def update
		@usuario = Usuario.find(params[:id])
		@usuario.unidade = current_unidade
		@usuario.entidade = current_unidade.entidade
		if @usuario.update_attributes(params[:usuario])
			redirect_to [:entidade, @usuario], notice: 'Usuário atualizado com sucesso!'
		else
			render action: :edit
		end
	end

	def change_status
		@usuario = Usuario.find(params[:id])
		if @usuario.situacao == Usuario::ATIVO
			@usuario.situacao = Usuario::INATIVO
		else
			@usuario.situacao = Usuario::ATIVO
		end
		@usuario.save
		redirect_to [:entidade, :usuarios], notice: 'Situação alterada com sucesso!'
	end

end
