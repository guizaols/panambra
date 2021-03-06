#encoding: UTF-8

class PlanoDeAcao < ActiveRecord::Base
  
  ### SITUACAO
  ABERTO     = 1
  FINALIZADO = 2

  attr_accessible :data_abertura
  attr_accessible :nome
  attr_accessible :responsavel_id
  attr_accessible :situacao
  attr_accessible :autocomplete_responsavel_id
  attr_accessor   :autocomplete_responsavel_id

  validates :nome, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 255 }
  validates :ponto_de_venda, presence: true
  validates :responsavel, presence: true

  has_many :item_plano_de_acoes

  belongs_to :responsavel, class_name: 'Usuario', foreign_key: 'responsavel_id'


  def initialize(attributes = {})
  	attributes['situacao'] ||= ABERTO
  	super
  end

  def situacao_verbose
  	case situacao
  	when ABERTO; 'Aberto'
  	when FINALIZADO; 'Finalizado'
  	end
  end

  def change_status
    situacao = (self.situacao == ABERTO ? FINALIZADO : ABERTO)
    self.update_column(:situacao, situacao)
  end

  def self.pesquisa(ponto_de_venda_id, params)
    plano_de_acoes = PlanoDeAcao.by_ponto_de_venda_id(ponto_de_venda_id)
    plano_de_acoes = plano_de_acoes.where('nome ILIKE ?', params[:nome].full_like) if params[:nome].present?
    plano_de_acoes
  end

end
