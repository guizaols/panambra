#encoding: UTF-8

class Resposta < ActiveRecord::Base

  attr_accessible :item_verificacao_id
  attr_accessible :agenda_id
  attr_accessible :resposta
  attr_accessible :resposta_texto

  validates :item_verificacao, presence: true
  validates :agenda, presence: true

  belongs_to :item_verificacao
  belongs_to :agenda
  
end
