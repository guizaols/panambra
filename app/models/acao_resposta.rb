#encoding: UTF-8

class AcaoResposta < ActiveRecord::Base

  attr_accessible :resposta_id
  attr_accessible :item_verificacao_id
  attr_accessible :comentarios
  attr_accessible :file_photo
  attr_accessible :status
  attr_accessible :alternativa_id

  belongs_to :resposta 
  belongs_to :item_verificacao
  belongs_to :alternativa

end
