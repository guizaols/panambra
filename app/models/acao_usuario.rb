#encoding: UTF-8

class AcaoUsuario < ActiveRecord::Base
  
	attr_accessible :acao_id
	attr_accessible :usuario_id

  belongs_to :acao
  belongs_to :usuario

end
