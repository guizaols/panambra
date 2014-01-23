#encoding: UTF-8

class Perfil < ActiveRecord::Base

  ATIVO 	= 1
  INATIVO = 2  

  attr_accessible :nome
  attr_accessible :permissoes
  attr_accessible :situacao
  attr_accessible :entidade_id

  serialize :permissoes, Hash

  belongs_to :entidade

  validates :nome, presence: true, uniqueness: { case_sensitive: false, scope: [:entidade_id] },
  								 length: { maximum: 255 }
  validates :permissoes, presence: true
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

  def self.retorna_perfil_para_select(entidade_id)
    Perfil.joins(:entidade)
          .where('perfils.situacao = ? AND entidades.id = ?', ATIVO,entidade_id)
          .collect{ |x| [x.nome, x.id] }
          .sort
  end

  def self.pesquisa(entidade_id, params)
    perfis = Perfil.by_entidade_id(entidade_id)
    perfis = perfis.where('nome ILIKE ?', params[:texto].full_like) if params[:texto].present?
    perfis = perfis.order(:nome)
  end

  def self.permissoes_for_select
    permissoes = YAML.load_file(Rails.root.join('config', 'permissoes.yml'))
    permissoes['permissoes']
  end

  def permitted_to?(controller, action)
    controller = controller.to_s
    action = action.to_s

    _permissoes = read_attribute(:permissoes)
    _permissoes_for_select = Perfil.permissoes_for_select['controllers']

    (!_permissoes_for_select.has_key?(controller)) || (!_permissoes_for_select[controller]['actions'].map { |key, value| value["methods"] }.flatten.include?(action)) || (_permissoes.has_key?(controller) && _permissoes[controller].map{ |action, status| _permissoes_for_select[controller]['actions'][action]['methods'] rescue false }.flatten.include?(action))
  end

end
