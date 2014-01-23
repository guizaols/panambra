#encoding: UTF-8

class ModuloEntidades::Administracao::PerfilsController < ApplicationController

	before_filter :verifica_se_o_usuario_eh_administrador_de_entidade

	def index
		params[:pesquisa] ||= {}
		@perfils = Perfil.pesquisa(current_entidade.id, params[:pesquisa]).page(params[:page]).per(15)
    respond_to do |format|
      format.html
      format.json { render json: @perfils }
    end
	end

	def show
		@perfil = Perfil.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @perfil }
    end
	end

	def new
		@perfil = Perfil.new
	end

	def create
		@perfil = Perfil.new(params[:perfil])
		@perfil.entidade = current_entidade
		if @perfil.save
			redirect_to [:entidade, :administracao, @perfil], notice: 'Registro cadastrado com sucesso!'
		else
			render :new
		end
	end

	def edit
		@perfil = Perfil.find(params[:id])
	end

	def update
		@perfil = Perfil.find(params[:id])
		if @perfil.update_attributes(params[:perfil]) && params[:perfil].has_key?(:permissoes)
			redirect_to [:entidade, :administracao, @perfil], notice: 'Registro atualizado com sucesso!'
		else
			flash[:error] = 'Permissões não pode ficar em branco'
			render :edit
		end
	end

  def change_status
    @perfil = Perfil.find(params[:id])
    @perfil.change_status
    respond_to do |format|
      format.html do
        redirect_to [:entidade, :administracao, :perfils], notice: 'Situação alterada com sucesso!'
      end
      format.json do
        head :no_content
      end
    end
  end

end
