class HomeController < ApplicationController

	before_filter :valid_payment
	

	def index
		# @retorno = Auditoria.retorna_auditoria_para_ser_respondida
		render layout: 'auditoria_inicial' if current_unidade.blank?
	end

  def primeiro_passo
  	render layout: 'auditoria_inicial'
  end

  def pesquisa_ordem_servico
	end

	def segundo_passo
		render layout: 'auditoria_inicial'
	end

	def iniciar_auditoria
		@retorno = Auditoria.cria_nova_auditoria(params[:ordem],"#{request.remote_ip}")
	end

	def ultimo_passo
		render layout: 'auditoria_inicial'
	end

end
