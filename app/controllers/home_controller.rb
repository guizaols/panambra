class HomeController < ApplicationController

	before_filter :valid_payment
	

	def index
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida
		render :layout=>"auditoria_inicial"
	end

end
