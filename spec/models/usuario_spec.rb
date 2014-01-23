#encoding: UTF-8
require 'spec_helper'



describe Usuario do

	describe 'Testes de Validações' do 

		it "Campos Obrigatórios" do
		    usuario = FactoryGirl.build(:usuario_administrador_geral_do_sistema_1, :email => "", :login=>"",:password=>"",:password_confirmation=>"",:tipo=>"")
		    usuario.should_not be_valid
		    usuario.should have(1).error_on(:login)
		    usuario.should have(1).error_on(:tipo)
		    usuario.should have(1).error_on(:email)
		    usuario.should have(1).error_on(:password)
	  	end

	end
end
