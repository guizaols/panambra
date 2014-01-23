#encoding: UTF-8

class ItemChecklist < ActiveRecord::Base

  ATIVO   = 1
  INATIVO = 2
	
  attr_accessible :checklist_id
  attr_accessible :item_checklist_id
  attr_accessible :nome
  attr_accessible :peso
  attr_accessible :situacao

  belongs_to :item_checklist
  belongs_to :checklist
  has_many   :item_checklists
  has_many   :item_verificacaos

  validates :checklist, presence: true
  validates :nome, presence: true
  validates :peso, presence: true, numericality: { greater_than_or_equal: 0 }
  

  def initialize(attributes = {})
		attributes['situacao'] ||= ATIVO
		super
	end

	def situacao_verbose
		case situacao
			when ATIVO; 'Ativo'
			when INATIVO; 'Inativo'
		end
	end

  def self.retorna_categoria_para_select(unidade_id)
    [''] + ItemChecklist.joins(:checklist)
                        .where('checklists.unidade_id = ? AND item_checklists.item_checklist_id IS NULL AND
                                item_checklists.situacao = ?',
                                unidade_id, ATIVO)
                        .collect{|x| [x.nome,x.id]}
  end

  def self.retorna_subcategoria_para_select(unidade_id, item_checklist_id)
    [''] + ItemChecklist.joins(:checklist)
                        .where('checklists.unidade_id = ? AND item_checklists.item_checklist_id = ? AND
                                item_checklists.situacao = ?',
                                unidade_id, item_checklist_id, ATIVO)
                        .collect{|x| [x.nome,x.id]}
  end

end
