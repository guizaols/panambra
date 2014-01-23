#encoding: UTF-8

class ModuloEntidades::Administracao::HomeController < ApplicationController

	before_filter :verifica_se_o_usuario_eh_administrador_de_entidade

	def index
	end
	
end
