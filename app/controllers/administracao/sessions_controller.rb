class Administracao::SessionsController < ::Devise::SessionsController
	
	before_filter :valid_payment
	
  # the rest is inherited, so it should work

end
