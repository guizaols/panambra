#encoding: UTF-8

class ModuloEntidades::PlanoDeAcoesController < ApplicationController

	before_filter :verifica_se_o_usuario_escolheu_uma_unidade
	before_filter :carrega_ponto_de_venda


	def index
		params[:pesquisa] ||= {}
		@plano_de_acoes = PlanoDeAcao.pesquisa(@ponto_de_venda.id, params[:pesquisa]).page(params[:page]).per(15)
	end

	def show
		@plano_de_acao = PlanoDeAcao.find(params[:id])
	end

	def new
		@plano_de_acao = PlanoDeAcao.new
	end

	def create
		@plano_de_acao = PlanoDeAcao.new(params[:plano_de_acao])
		@plano_de_acao.ponto_de_venda = @ponto_de_venda
		if @plano_de_acao.save
			redirect_to [:entidade, @ponto_de_venda, :plano_de_acoes], notice: 'Plano de ação criado com sucesso!'
		else
			render :new
		end
	end

	def edit
		@plano_de_acao = PlanoDeAcao.find(params[:id])
	end

	def update
		@plano_de_acao = PlanoDeAcao.find(params[:id])
		@plano_de_acao.ponto_de_venda = @ponto_de_venda
		if @plano_de_acao.update_attributes(params[:plano_de_acao])
			redirect_to [:entidade, @ponto_de_venda, :plano_de_acoes], notice: 'Plano de ação atualizado com sucesso!'
		else
			render :edit
		end
	end

	def destroy
		@plano_de_acao = PlanoDeAcao.find(params[:id])
		@plano_de_acao.destroy
		redirect_to [:entidade, @ponto_de_venda, :plano_de_acoes], notice: 'Plano de ação excluído com sucesso!'
	end

	def change_status
		@plano_de_acao = PlanoDeAcao.find(params[:id])
		@plano_de_acao.ponto_de_venda = @ponto_de_venda
    @plano_de_acao.change_status
    respond_to do |format|
      format.html do
        redirect_to [:entidade, @ponto_de_venda, :plano_de_acoes], notice: 'Status alterado com sucesso!'
      end
      format.json do
        head :no_content
      end
    end
	end

	def new_agenda
		@agenda = Agenda.new
		@plano_de_acao = PlanoDeAcao.find(params[:id])
		render('new_agenda', layout: false)
	end

  def create_agenda
    @agenda = Agenda.new(params[:agenda])
		@plano_de_acao = PlanoDeAcao.find(params[:id])
    respond_to do |format|
      @agenda.unidade = current_unidade
      if @agenda.save
      	if params[:agendas][:usuarios].present?
      		@agenda.usuarios << Usuario.find(params[:agendas][:usuarios].uniq.reject(&:empty?))
      	end
      	@item_plano_de_acao = ItemPlanoDeAcao.new
      	@item_plano_de_acao.agenda_id = @agenda.id
      	@item_plano_de_acao.plano_de_acao_id = @plano_de_acao.id
      	@item_plano_de_acao.usuario_id = @agenda.usuario.id
      	@item_plano_de_acao.save
        @agenda.envia_emails_para_participantes
        format.js do
          render js: "alert('Agenda cadastrada com sucesso'); window.location.reload();"
        end
      else
        format.js
      end
    end
  end


  private

  	def carrega_ponto_de_venda
  		@ponto_de_venda = PontoDeVenda.find(params[:ponto_de_venda_id])
  	end

end
