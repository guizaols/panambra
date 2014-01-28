#encoding: UTF-8

class Acao < ActiveRecord::Base
  
  self.table_name = 'acoes'

  # TIRAR_FOTO   = 34531
  ENVIAR_EMAIL = 67543
  # GERAR_TAREFA = 34589
  # COMENTARIO   = 12387

  attr_accessible :tipo
  attr_accessible :alternativa_id
  attr_accessible :item_verificacao_id
  attr_accessible :usuario_ids

  belongs_to :item_verificacao
  belongs_to :questao
  belongs_to :alternativa
  has_many   :acao_usuarios
  has_many   :usuarios, through: :acao_usuarios, uniq: true

  validates :tipo, presence: true,
                   uniqueness: { case_sensitive: false, scope: [:item_verificacao_id, :alternativa_id] },
                   inclusion: { in:[ENVIAR_EMAIL] }
  validates :usuario_ids, presence: true, if: :tipo_enviar_email?

  def tipo_enviar_email?
  	self.tipo == ENVIAR_EMAIL
  end

  def tipo_verbose
  	case tipo
	  	# when TIRAR_FOTO; 'Tirar foto'
	  	when ENVIAR_EMAIL; 'Enviar e-mail'
	  	# when GERAR_TAREFA; 'Gerar tarefa'
	  	# when COMENTARIO; 'Comentário'
  	end
  end

  def self.retorna_tipo_para_select
  	[
  		# ['Tirar foto', TIRAR_FOTO],
  		['Enviar e-mail', ENVIAR_EMAIL]
  		# ['Gerar tarefa', GERAR_TAREFA],
  		# ['Comentário', COMENTARIO]
  	]
  end

end
