class ConexaoPanambra < ActiveRecord::Base
  
  self.abstract_class = true
  establish_connection('erp_panambra')

end
