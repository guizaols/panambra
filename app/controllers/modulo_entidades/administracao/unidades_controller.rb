#encoding: UTF-8

class ModuloEntidades::Administracao::UnidadesController < ApplicationController

	before_filter :verifica_se_o_usuario_eh_administrador_de_entidade

	def index
		params[:pesquisa] ||= {}
		@unidades = Unidade.pesquisa(current_entidade.id, params[:pesquisa]).page(params[:page]).per(15)
	end

	def show
		@unidade = Unidade.find(params[:id])
	end

	def new
		@unidade = Unidade.new
	end

	def create
		@unidade = Unidade.new(params[:unidade])
		@unidade.entidade = current_entidade
		if @unidade.save
			redirect_to [:entidade, :administracao, @unidade], notice: 'Unidade criada com sucesso!'
		else
			render :new
		end
	end

	def edit
		@unidade = Unidade.find(params[:id])
	end

	def update
		@unidade = Unidade.find(params[:id])
		if @unidade.update_attributes(params[:unidade])
			redirect_to [:entidade, :administracao, @unidade], notice: 'Unidade atualizada com sucesso!'
		else
			render :edit
		end
	end

  def change_status
    @unidade = Unidade.find(params[:id])
    @unidade.change_status
    respond_to do |format|
      format.html do
        redirect_to [:entidade, :administracao, :unidades], notice: 'Status alterado com sucesso!'
      end
      format.json do
        head :no_content
      end
    end
  end

	def escolher_unidade
	end

	def sair_unidade
		session[:unidade] = nil
		redirect_to [:escolher_unidade,:entidade, :administracao, :unidades]
	end

	def acessando_unidade
		session[:unidade] = Unidade.find_by_id(params[:unidade_id])
		if session[:unidade].blank?
			flash[:error] = 'Erro! Você deve selecionar uma unidade!'
			redirect_to root_path
		else
			redirect_to [:entidade,:root]
		end
	end

end
