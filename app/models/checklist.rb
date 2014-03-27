#encoding: UTF-8

class Checklist < ActiveRecord::Base

  ### SITUACAO
  ATIVO	  = 1
  INATIVO = 2  

  attr_accessible :nome
  attr_accessible :situacao

  belongs_to :unidade
  has_many   :item_checklists

  validates :nome, presence: true,
                   uniqueness: { case_sensitive: false, scope: [:unidade_id] },
  								 length: { maximum: 255 }
  validates :unidade, presence: true
  validates :situacao, presence: true
  validate  :valida_se_ja_existe_um_ativo_na_unidade

  scope :by_unidade_id, lambda { |unidade_id| where(unidade_id: unidade_id) }


  # def initialize(attributes = {})
  # 	attributes['situacao'] ||= ATIVO
  # 	super
  # end

  def situacao_verbose
  	case situacao
  	when ATIVO; 'Ativo'
  	when INATIVO; 'Inativo'
  	end
  end

  def change_status
    situacao = (self.situacao == ATIVO ? INATIVO : ATIVO)
    self.update_column(:situacao, situacao)
  end

  def self.pesquisa(unidade_id, params)
    checklists = Checklist.by_unidade_id(unidade_id)
    checklists = checklists.where('nome ILIKE ?', params[:texto].full_like) if params[:texto].present?
    checklists = checklists.order(:nome)
    checklists
  end

  def self.retorna_situacao_para_select
    [
      ['Ativo', ATIVO],
      ['Inativo', INATIVO]
    ]
  end

  def self.retorna_setores_para_select(unidade_id)
    Checklist.where(situacao: ATIVO, unidade_id: unidade_id).collect{ |x| [x.nome, x.id] }
  end

  def self.retorna_checklist_para_select(unidade_id)
    Checklist.where(situacao: ATIVO, unidade_id: unidade_id).collect{|x| [x.nome,x.id]}
  end

  def carrega_categorias
    self.item_checklists.joins(:checklist)
                        .where('checklists.unidade_id = ? AND
                                item_checklists.checklist_id = ? AND
                                item_checklists.item_checklist_id IS NULL AND
                                item_checklists.situacao = ?',
                                self.unidade.id, self.id, ATIVO)
  end

  def valida_se_ja_existe_um_ativo_na_unidade
    if self.situacao == ATIVO && self.unidade.checklists.where(situacao: ATIVO).present?
      errors.add :base, 'Já existe um checklist ativo na unidade!'
    end
  end

end
