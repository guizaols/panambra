class Administracao::PasswordsController < Devise::PasswordsController

	before_filter :valid_payment

end
