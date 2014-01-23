#encoding: UTF-8
class Administracao::EntidadesController < ApplicationController

	before_filter :verifica_se_o_usuario_eh_administrador_do_sistema

	def index
		params[:pesquisa] ||= {}
		unless params[:pesquisa][:texto].blank?
			@entidades = Entidade.pesquisa(params[:pesquisa]).page(params[:page]).per(15)
		else
			@entidades = Entidade.order(:nome).page(params[:page]).per(15)
		end
		
	end

	def show
		@entidade = Entidade.find params[:id]
		@usuario = @entidade.administrador_entidade
	end

	def new
		@entidade = Entidade.new
		@usuario = @entidade.usuarios.build

	end

	def create
		@entidade = Entidade.new params[:entidade]
		@entidade.usuarios.first.tipo = Usuario::ADMINISTRADOR_ENTIDADE
		if @entidade.save
			redirect_to [:administracao,@entidade], notice:"Entidade criada com sucesso!"
		else
			render :new
		end
	end

	def change_status
		@entidade = Entidade.find params[:id]
		if @entidade.situacao == Entidade::ATIVO
			@entidade.situacao = Entidade::INATIVO
		else
			@entidade.situacao = Entidade::ATIVO
		end
		if @entidade.save
			redirect_to [:administracao,:entidades],:notice=>"Situação alterada com sucesso!"
		else
			redirect_to [:administracao,:entidades],:notice=>"Não foi possível alterar a situação do registro!"
		end
	end

	def edit
		@entidade = Entidade.find params[:id]
	end

	def update
		@entidade = Entidade.find params[:id]
		if @entidade.update_attributes(params[:entidade])
			redirect_to [:administracao,@entidade], notice:"Entidade atualizada com sucesso!"
		else
			render :edit
		end
	end
end
