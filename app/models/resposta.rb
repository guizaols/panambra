#encoding: UTF-8

class Resposta < ActiveRecord::Base

	### ALTERNATIVAS
	SIM = 58324
	NAO = 43239

  attr_accessible :resposta
  attr_accessible :resposta_texto
  attr_accessible :auditoria_id
  attr_accessible :item_verificacao_id

  belongs_to :auditoria
  belongs_to :item_verificacao
  
	validates :auditoria, presence: true
	validates :item_verificacao, presence: true	


  def resposta_verbose
		case resposta
			when SIM; 'Sim'
			when NAO; 'Não'
			else; (Alternativa.find(self.resposta).titulo rescue nil)
		end
	end

end
