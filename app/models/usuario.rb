#encoding: UTF-8

class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  ### TIPOS  
  ADMINISTRADOR_GERAL_DO_SISTEMA = 1
  ADMINISTRADOR_ENTIDADE         = 2
  ADMINISTRADOR_UNIDADE          = 3
  CAIXA                          = 4
  CLIENTE                        = 5
  
  ### STATUS
  ATIVO   = 1
  INATIVO = 2

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email
  attr_accessible :password
  attr_accessible :password_confirmation
  attr_accessible :remember_me
  attr_accessible :nome
  attr_accessible :login
  attr_accessible :setor_id
  attr_accessible :usuario_superior_id
  attr_accessible :perfil_id
  attr_accessible :situacao
  attr_accessible :tipo
  attr_accessible :ramal
  attr_accessible :telefone
  attr_accessible :celular

  belongs_to :entidade
  belongs_to :perfil
  belongs_to :unidade
  belongs_to :perfil
  belongs_to :usuario_superior, class_name: 'Usuario', foreign_key: 'usuario_superior_id'
  belongs_to :setor
  has_many   :usuario_ponto_de_vendas
  has_many   :agenda_usuarios
  has_many   :agendas, through: :agenda_usuarios, uniq: true
  
  validates :login, presence: true,uniqueness: { case_sensitive: false, scope: [:unidade_id] }, length: { maximum: 255 }
  validates :tipo, presence: true
  validates :perfil, presence:true, if: :eh_usuario_comum?
  validates :setor, presence:true, if: :eh_usuario_administrador_da_entidade?
  validates :usuario_superior, presence:true, if: :eh_usuario_comum?
  validates :email, uniqueness: { case_sensitive: false, scope: [:tipo,:unidade_id] }, length: { maximum: 255 }

  before_validation :definir_como_ativo

  scope :by_entidade_id, lambda { |entidade_id| where(entidade_id: entidade_id) }
  scope :by_unidade_id, lambda { |unidade_id| where(unidade_id: unidade_id) }

  attr_accessor :authentication_key

  before_create :create_authentication_token

  scope :search_by_authentication_key, lambda { |authentication_key| search_by_email_or_login(*([authentication_key] * 2)) }
  scope :search_by_email_or_login, lambda { |email, username| where("(email LIKE ?) OR (login LIKE ?)", email, username) }

  
  def self.authenticate(authentication_key, password)
    user = search_by_authentication_key(authentication_key).first
    user ||= new

    if user.new_record?
      user.errors.add :authentication_key, :invalid
     elsif user.situacao == INATIVO
       user.errors.add :authentication_key, :inactive
    elsif user.tipo != CAIXA
      user.errors.add :base, 'Este não é um usuário de vendas'
    # elsif !user.authenticate password
    #   user.errors.add :password, :invalid
    end

    user
  end

  def create_authentication_token
    write_attribute :authentication_token, generate_token(:authentication_token)
  end
  alias_method :update_authentication_token, :create_authentication_token


  def generate_token(attribute_name)
    begin
      token = SecureRandom.hex
    end while self.class.exists?(attribute_name => token)
    token
  end

  def eh_usuario_comum?
    ![ADMINISTRADOR_GERAL_DO_SISTEMA, ADMINISTRADOR_ENTIDADE, ADMINISTRADOR_UNIDADE].include?(self.tipo)
  end

  def eh_usuario_administrador_da_entidade?
    ![ADMINISTRADOR_GERAL_DO_SISTEMA, ADMINISTRADOR_ENTIDADE].include?(self.tipo)
  end

  def definir_como_ativo
    self.situacao = ATIVO if self.new_record?
  end

  def self.pesquisa(unidade_id, params)
    usuarios = Usuario.where('unidade_id = ? AND tipo IN (?)', unidade_id, [3, 4, 5] )
    usuarios = usuarios.where('nome ILIKE ? OR login ILIKE ?', params[:texto].full_like, params[:texto].full_like) if params[:texto].present?
    usuarios = usuarios.order(:nome)
    usuarios
  end

  def self.pesquisa_usuarios_comum(unidade_id, params)
    usuarios = Usuario.where('unidade_id = ? AND tipo IN (?)', unidade_id, [3, 4])
    usuarios = usuarios.where('nome ILIKE ? OR login ILIKE ?', params[:texto].full_like, params[:texto].full_like) if params[:texto].present?
    usuarios = usuarios.order(:nome)
    usuarios
  end

  def self.pesquisa_administradores(params)
    usuarios = Usuario.where("tipo IN (?)",[1])
    usuarios = usuarios.where('nome ILIKE ? OR login ILIKE ?', params[:texto].full_like, params[:texto].full_like) if params[:texto].present?
    usuarios = usuarios.order(:nome)
    usuarios
  end

  def self.retorna_tipo_para_select
    [
      ['Administrador da Unidade', ADMINISTRADOR_UNIDADE],
      ['Cliente', CLIENTE],
      ['Caixa', CAIXA]
    ]
  end

  def tipo_verbose
    case tipo
      when ADMINISTRADOR_GERAL_DO_SISTEMA; 'Administrador Geral do Sistema'
      when ADMINISTRADOR_ENTIDADE; 'Administrador da Entidade'
      when ADMINISTRADOR_UNIDADE; 'Administrador da Unidade'
      when CLIENTE; 'Cliente'
      when CAIXA; 'Caixa'
    end
  end
  
  def permitted_to?(controller, action)
    if [CLIENTE, CAIXA].include?(self.tipo)
      self.perfil.present? && self.perfil.permitted_to?(controller, action)
    else
      true
    end
  end

  def situacao_verbose
    case situacao
    when ATIVO; 'Ativo'
    when INATIVO; 'Inativo'
    end
  end


### Overwrite Devise's Method Autentication
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
end
