#encoding: UTF-8

class Entidade < ActiveRecord::Base
  
  ### SITUACAO
  ATIVO   = 1
  INATIVO = 2

  attr_accessible :nome
  attr_accessible :slug
  attr_accessible :situacao
  attr_accessible :usuarios_attributes

  validates :nome, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :slug, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 255 }, format: { with: /\A[a-z0-9]+\z/ }
               

  ### O dependent: destroy não foi testado
  has_many :usuarios, dependent: :destroy
  has_many :perfils, dependent: :destroy
  has_many :unidades, dependent: :destroy
  
  accepts_nested_attributes_for :usuarios


  def initialize(attributes = {})
  	attributes['situacao'] ||= ATIVO
  	super
  end

  def self.pesquisa(params)
    Entidade.where('nome ILIKE ? OR slug ILIKE ?', params[:texto].full_like,params[:texto].full_like)
  end

  def situacao_verbose
  	case situacao
  	when ATIVO;"Ativo"
  	when INATIVO;"Inativo"
  	end
  end


  def administrador_entidade
    self.usuarios.where('tipo = ?', Usuario::ADMINISTRADOR_ENTIDADE).first
  end

  def self.retorna_situacao_para_select
    [
      ['Ativo', ATIVO],
      ['Inativo', INATIVO]
    ]
  end

end
