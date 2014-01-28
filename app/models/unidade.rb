#encoding: UTF-8

class Unidade < ActiveRecord::Base

  ATIVO 	= 1
  INATIVO = 2  

  attr_accessible :nome
  attr_accessible :slug
  attr_accessible :situacao
  attr_accessible :entidade_id

  belongs_to :entidade
  has_many :usuarios, dependent: :destroy
  has_many :checklists, dependent: :destroy
  has_many :auditorias, dependent: :destroy

  validates :nome, presence: true, uniqueness: { case_sensitive: false, scope: [:entidade_id] },
  								 length: { maximum: 255 }
  # validates :slug, presence: true, uniqueness: { case_sensitive: false, scope: [:entidade_id] },
  # 								 length: { maximum: 255 }, format: { with: /\A[a-z0-9]+\z/ }
  validates :entidade, presence: true

  scope :by_entidade_id, lambda { |entidade_id| where(entidade_id: entidade_id) }


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

  def change_status
    situacao = (self.situacao == ATIVO ? INATIVO : ATIVO)
    self.update_column(:situacao, situacao)
  end

  def self.return_unidades_para_select(current_entidade_id)
    Unidade.where("situacao = ? AND entidade_id = ?",ATIVO,current_entidade_id).collect{|unid| [unid.nome, unid.id]}
  end

  def self.pesquisa(entidade_id, params)
    unidades = Unidade.by_entidade_id(entidade_id)
    unidades = unidades.where('nome ILIKE ? OR slug ILIKE ?', params[:texto].full_like, params[:texto].full_like) if params[:texto].present?
    unidades = unidades.order(:nome)
    unidades
  end

  def retorna_checklist_ativo
    self.checklists.where(situacao: Checklist::ATIVO).first rescue nil
  end

end
