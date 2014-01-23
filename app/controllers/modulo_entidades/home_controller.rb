#encoding: UTF-8

class ModuloEntidades::HomeController < ApplicationController

	before_filter :verifica_se_esta_logado

	def index
	end
	
end
