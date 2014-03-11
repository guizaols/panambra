#encoding: UTF-8

class ItemVerificacao < ActiveRecord::Base
  
  self.table_name = 'item_verificacaos'

  ### SITUACAO
  ATIVO   = 1
  INATIVO = 2

  ### TIPO
  SIM_NAO       = 1
  SIM_NAO_TEXTO = 2
  TEXTO         = 3
  ESCALA        = 4

  attr_accessible :item_checklist_id
  attr_accessible :tipo
  attr_accessible :titulo
  attr_accessible :alternativas_attributes
  attr_accessible :situacao
  attr_accessible :de_para

  belongs_to :item_checklist
  has_many   :alternativas
  has_many   :acoes, class_name: 'Acao', foreign_key: 'item_verificacao_id'
  accepts_nested_attributes_for :alternativas, allow_destroy: true

  validates :tipo,  presence: true, inclusion: { in: [SIM_NAO, SIM_NAO_TEXTO, TEXTO,ESCALA] }
  validates :titulo, presence: true
  validates :item_checklist, presence: true


  def initialize(attributes = {})
    attributes['situacao'] ||= ATIVO
    super
  end

  def self.retorna_tipo_para_select
  	[
  		['Sim/Não', SIM_NAO],
  		['Sim/Não + Texto', SIM_NAO_TEXTO],
  		['Texto', TEXTO],
      ['Escala',ESCALA]
  	]
  end

  def tipo_verbose
  	case tipo
  		when SIM_NAO; 'Sim/Não'
  		when SIM_NAO_TEXTO; 'Sim/Não + Texto'
  		when TEXTO; 'Texto'
      when ESCALA; 'Escala'
  	end
  end


end
