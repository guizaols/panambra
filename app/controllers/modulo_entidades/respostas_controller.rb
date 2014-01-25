#encoding: UTF-8

class ModuloEntidades::RespostasController < ApplicationController

	before_filter :verifica_se_esta_logado
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade


	def index
	end


end
