#encoding: UTF-8

class Acao < ActiveRecord::Base
  
self.table_name = 'acoes'

  TIRAR_FOTO = 1
  ENVIAR_EMAIL = 2
  GERAR_TAREFA = 3
  COMENTARIO = 4 



  attr_accessible :alternativa_id
  attr_accessible :destinatarios
  attr_accessible :item_verificacao_id
  attr_accessible :tipo


  validates :tipo,:presence=>true, inclusion: {in:[TIRAR_FOTO, ENVIAR_EMAIL,GERAR_TAREFA,COMENTARIO]}
  validates :destinatarios,:presence=>true, :if=>:tipo_enviar_email?

  belongs_to :item_verificacao
  belongs_to :alternativa

  before_validation :limpa_destinatarios


  def limpa_destinatarios
  	self.destinatarios = "" if tipo.present? && tipo != ENVIAR_EMAIL
  end



  def tipo_enviar_email?
  	self.tipo == ENVIAR_EMAIL
  end


  def tipo_verbose
  	case tipo
	  	when TIRAR_FOTO;"Tirar Foto"
	  	when ENVIAR_EMAIL;"Enviar E-mail"
	  	when GERAR_TAREFA;"Gerar Tarefa"
	  	when COMENTARIO;"Comentário"
  	end
  end

  def self.retorna_tipo_para_select
  	[
  		[""],
  		["Tirar Foto",TIRAR_FOTO],
  		["Enviar E-mail",ENVIAR_EMAIL],
  		["Gerar Tarefa",GERAR_TAREFA],
  		["Comentário",COMENTARIO]
  	]
  end



end
