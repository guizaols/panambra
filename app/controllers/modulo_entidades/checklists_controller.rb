#encoding: UTF-8

class ModuloEntidades::ChecklistsController < ApplicationController

	before_filter :verifica_se_o_usuario_escolheu_uma_unidade


	def index
		params[:pesquisa] ||= {}
		@checklists = Checklist.pesquisa(current_unidade.id, params[:pesquisa]).page(params[:page]).per(15)
	end

	def show
		@checklist = Checklist.find(params[:id])
		# @item_checklists = ItemChecklist.carrega_categorias(current_unidade)
		@item_checklists = @checklist.carrega_categorias
	end

	def new
		@checklist = Checklist.new
	end

	def create
		@checklist = Checklist.new(params[:checklist])
		@checklist.unidade = current_unidade
		if @checklist.save
			redirect_to [:entidade, @checklist], notice: 'Checklist criado com sucesso!'
		else
			render :new
		end
	end

	def edit
		@checklist = Checklist.find(params[:id])
	end

	def edit_categoria_ajax
		@item_checklist = ItemChecklist.find(params[:id])
		@checklist = @item_checklist.checklist
		respond_to do |format|
			format.js
		end
	end

	def edit_questao_ajax
		@item_verificacao  = ItemVerificacao.find(params[:id])
		@item_checklist = @item_verificacao.item_checklist
		@checklist = @item_checklist.checklist
		respond_to do |format|
			format.js
		end
	end

	def detalhe_questao
		@item_verificacao  = ItemVerificacao.find(params[:id])
		@item_checklist = @item_verificacao.item_checklist
		@checklist = @item_checklist.checklist
		respond_to do |format|
			format.js
		end
	end

	def nova_acao
		@item_verificacao  = ItemVerificacao.find(params[:id])
		@alternativas = @item_verificacao.alternativas
		@acoes = @item_verificacao.acoes
		@item_checklist = @item_verificacao.item_checklist
		@checklist = @item_checklist.checklist
		respond_to do |format|
			format.js{}
		end
	end

	
	def update
		@checklist = Checklist.find(params[:id])
		@checklist.unidade = current_unidade
		if @checklist.update_attributes(params[:checklist])
			redirect_to [:entidade, @checklist], notice: 'Checklist atualizado com sucesso!'
		else
			render :edit
		end
	end

	def altera_situacao_categoria
		@item_checklist = ItemChecklist.find(params[:id])
		if @item_checklist.situacao == ItemChecklist::ATIVO 
			@item_checklist.situacao = ItemChecklist::INATIVO
		else
			@item_checklist.situacao = ItemChecklist::ATIVO
		end
		@item_checklist.save
		render js: "alert('Situação alterada com sucesso!');window.location.reload();"
	end

	def altera_situacao_questao
		@item_verificacao = ItemVerificacao.find(params[:id])
		if @item_verificacao.situacao == ItemVerificacao::ATIVO 
			@item_verificacao.situacao = ItemVerificacao::INATIVO
		else
			@item_verificacao.situacao = ItemVerificacao::ATIVO
		end
		@item_verificacao.save
		render js: "alert('Situação alterada com sucesso!');window.location.reload();"
	end

  def change_status
    @checklist = Checklist.find(params[:id])
    @checklist.change_status
    respond_to do |format|
      format.html do
        redirect_to [:entidade, :checklists], notice: 'Status alterado com sucesso!'
      end
      format.json do
        head :no_content
      end
    end
  end
end
