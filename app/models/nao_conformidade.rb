class NaoConformidade < ActiveRecord::Base
  attr_accessible :cliente_id
  attr_accessible :comentarios
  attr_accessible :data
  attr_accessible :data_escalonada
  attr_accessible :item_verificacao_id
  attr_accessible :auditoria_id
  attr_accessible :unidade_id
  
  attr_accessible :usuario_delegado_id
  attr_accessible :usuario_id

  belongs_to :cliente
  belongs_to :usuario
  belongs_to :usuario_delegado, :foreign_key=>"usuario_delegado_id",:class_name=>"Usuario"
  belongs_to :item_verificacao
  belongs_to :auditoria
  belongs_to :unidade

  validates :cliente,presence: true
  validates :item_verificacao,presence: true
  validates :data,presence: true
  validates :status,presence: true

  CRIADO = 1
  ESCALONADO = 2
  FINALIZADO = 3

  def status_verbose
    case status
      when CRIADO; "Criado"
      when ESCALONADO; "Escalonado"
      when FINALIZADO; "Finalizado"
    end
  end


end
