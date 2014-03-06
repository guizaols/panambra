#encoding: UTF-8

class ModuloEntidades::Administracao::ConfiguracoesController < ApplicationController

	before_filter :valid_payment
	before_filter :verifica_se_o_usuario_eh_administrador_de_entidade

	def edit
		@configuracao = Configuracao.last
	end

	def update
		@configuracao = Configuracao.find(params[:id])
		if @configuracao.update_attributes(params[:configuracao])
			redirect_to [:edit, :entidade, :administracao, @configuracao], notice: 'Configuração atualizada com sucesso!'
		else
			render action: :edit
		end
	end

end
