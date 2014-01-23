#encoding: UTF-8

class ItemPlanoDeAcao < ActiveRecord::Base

  ### STATUS
  ATIVO   = 1
  INATIVO = 2

  attr_accessible :agenda_id
  attr_accessible :plano_de_acao_id
  attr_accessible :usuario_id
  attr_accessible :status
  attr_accessible :data_finalizacao
  attr_accessible :comentarios

  belongs_to :plano_de_acao
  belongs_to :agenda
  belongs_to :usuario

  validates :plano_de_acao, presence: true
  validates :agenda, presence: true
  validates :usuario, presence: true


  def initialize(attributes = {})
		attributes['status'] ||= ATIVO
		super
	end

	def status_verbose
		case status
			when ATIVO; 'Ativo'
			when INATIVO; 'Inativo'
		end
	end

end
