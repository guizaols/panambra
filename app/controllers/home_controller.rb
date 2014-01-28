class HomeController < ApplicationController

	def index
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida
	end
	
end
