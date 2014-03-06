#encoding: UTF-8

class Configuracao < ActiveRecord::Base

  attr_accessible :empresa
	attr_accessible :revenda
	attr_accessible :situacao
	attr_accessible :des_contato
	attr_accessible :ativo_passivo
  attr_accessible :departamento
  attr_accessible :tipo_contato
  attr_accessible :subtipo_contato
  attr_accessible :forma_contato
  attr_accessible :origem
  attr_accessible :providencia
  attr_accessible :tipo_providencia
  attr_accessible :subtipo_providencia
	attr_accessible :questionario


	def self.retorna_configuracao
		Configuracao.last.present? ? Configuracao.last : Configuracao.create!
	end

end
