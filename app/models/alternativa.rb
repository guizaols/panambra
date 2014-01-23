#encoding: UTF-8

class Alternativa < ActiveRecord::Base

  attr_accessible :item_verificacao_id
  attr_accessible :peso
  attr_accessible :titulo

  belongs_to :item_verificacao

  
  validates :titulo, presence: true
  validates :peso, presence: true
  # validates :item_verificacao, presence: true

  has_many :acoes

end
