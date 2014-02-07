class Administracao::RegistrationsController < Devise::RegistrationsController

	before_filter :valid_payment
	
end
