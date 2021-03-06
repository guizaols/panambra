#encoding: UTF-8

class ModuloEntidades::QuestoesController < ApplicationController

	before_filter :valid_payment
	before_filter :verifica_se_esta_logado
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade
	before_filter :carrega_checklist

	def index
		@item_checklists = @checklist.item_checklists
		@questoes = []
		@item_checklists.each do |item|
			item.item_verificacaos.each do |q|
				@questoes << q
			end
		end
	end

	def nova_categoria_questao
		@item_checklist = ItemChecklist.new(params[:item_checklist])
		@item_checklist.checklist = @checklist
		respond_to do |format|
		  format.js
	  end
	end

	def nova_subcategoria_questao
		@item_checklist = ItemChecklist.new(params[:item_checklist])
		@item_checklist.checklist = @checklist
		respond_to do |format|
		  format.js
	  end
	end

	def carrega_subcategoria
		@item_checklist = ItemChecklist.find(params[:categoria_questao_id])
		respond_to do |format|
		  format.js
	  end
	end

	def carrega_alternativa
		respond_to do |format|
		  format.js
	  end
	end

	def nova_questao
		@item_verificacao = ItemVerificacao.new(params[:item_verificacao])
	end

	def cria_acao
		@item_verificacao = ItemVerificacao.find(params[:id])
		@acao = Acao.new params[:acao]
		@acao.item_verificacao = @item_verificacao
		respond_to do |format|
		  format.js
	  end
	end

	def carrega_form_questao
		@item_checklist = ItemChecklist.find(params[:subcategoria_questao_id])
		respond_to do |format|
		  format.js
	  end
	end

	def atualiza_categoria
		@item_checklist = ItemChecklist.find(params[:id])
		respond_to do |format|
			format.js
		end
	end

	def atualiza_item_verificacao
		@item_verificacao = ItemVerificacao.find(params[:id])
		respond_to do |format|
			format.js
		end
	end

	def inserir_imagem
		@item_verificacao = ItemVerificacao.find(params[:questao_id])
		@alternativas = @item_verificacao.alternativas
	end

	def upload_imagem
		unless params[:arquivo].blank?
			@alternativa = Alternativa.find params[:item_verificacao][:alternativa_id]
			@alternativa.arquivo = params[:arquivo]
			@alternativa.save!
			redirect_to [:entidade, @checklist,:questoes], notice: 'Arquivo adicionado com sucesso!'
		else
			redirect_to [:entidade, @checklist,:questoes], error: 'Adicionar um arquivo é obrigatório!'
		end
	end


private

	def carrega_checklist
		@checklist = Checklist.find(params[:checklist_id])
	end

end
