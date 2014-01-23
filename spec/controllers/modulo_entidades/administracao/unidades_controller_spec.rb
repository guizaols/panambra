#encoding: UTF-8

require 'spec_helper'

describe ModuloEntidades::Administracao::UnidadesController do

	describe "GET#INDEX" do
		it "Testando retorno action Index" do 
			unidade_1 = FactoryGirl.create(:unidade_1)
			unidade_2 = FactoryGirl.create(:unidade_2)
			unidade_3 = FactoryGirl.create(:unidade_3)
			get :index
			assigns(:unidades).should eq([unidade_1, unidade_2, unidade_3])
		end

		it "Testando template index" do 
			get :index
			response.should render_template :index
		end

	end

end
