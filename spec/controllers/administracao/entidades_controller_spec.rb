#encoding: UTF-8
require 'spec_helper'

describe Administracao::EntidadesController do

	describe "GET#INDEX" do
		it "Testando retorno action Index" do 
			entidade_1 = FactoryGirl.create(:entidade_1)
			entidade_2 = FactoryGirl.create(:entidade_2)
			entidade_3 = FactoryGirl.create(:entidade_3)
			get :index
			assigns(:entidades).should eq([entidade_1,entidade_2,entidade_3])
		end

		it "Testando template index" do 
			get :index 
			response.should render_template :index
		end

	end

	describe "GET#SHOW" do 
		
		it "Testando retorno action Show" do 
			entidade = FactoryGirl.create(:entidade_1)
			get :show, id: entidade.id
			assigns(:entidade).should eq(entidade)
		end

		it "Testando template show" do 
			entidade = FactoryGirl.create(:entidade_1)
			get :show, id: entidade.id 
			response.should render_template :show
		end
	end


	describe "GET#NEW" do 
		it "Testando retorno action New" do 
			get :new
			assigns(:entidade).nome.should be_nil
		end

		it "Testando template new" do 
			get :new
			response.should render_template :new
		end
	end

	describe "POST#CREATE" do 

		context "with valid attributes" do 
			it "Cria um novo registro" do 
				expect{
					Entidade.delete_all
					post :create,:entidade => FactoryGirl.attributes_for(:entidade_1)
				}.to change(Entidade,:count).by(1)
			end

			it "Redireciona para a tela index após salvar com sucesso" do 
				post :create, entidade: {:nome=>"Teste",:slug=>"teste"}
				response.should redirect_to [:administracao,Entidade.last]
			end
		end

		context "with invalid attributes" do 
			it "Não pode salvar um novo registro" do 
				expect{
					post :create,:entidade => {:nome => "", :slug=>""}
				}.to_not change(Entidade,:count)
			end

			it "Renderizar view" do 
				post :create,:entidade => {:nome => "", :slug=>""}
				response.should render_template :new
			end
		end
	end


	describe "GET#EDIT" do

		it "Testando retorno da action edit" do 
			entidade = FactoryGirl.create(:entidade_1)
			get :edit, id: entidade
			assigns(:entidade).should eq(entidade)
		end

		it "Testando template edit" do 
			entidade = FactoryGirl.create(:entidade_1)
			get :edit, id: entidade
			response.should render_template :edit
		end
	end

	describe "PUT#UPDATE" do 
		
	

		context "atributos válidos" do

			it "Testando find da action update" do 
				Entidade.delete_all
				@entidade = FactoryGirl.create(:entidade_1)
				put :update, id: @entidade.id, entidade: FactoryGirl.attributes_for(:entidade_1)
				assigns(:entidade).should eq(@entidade)
			end

			it "Atualizando atributo" do 
				Entidade.delete_all
				@entidade = FactoryGirl.create(:entidade_1)
				put :update, id: @entidade.id, entidade: FactoryGirl.attributes_for(:entidade_1,:nome=>"Atualizacao")
				@entidade.reload
				assigns(:entidade).should eq(@entidade)
				@entidade.nome.should eq("Atualizacao")
			end

			it "Testando redirecionamento" do 
				Entidade.delete_all
				@entidade = FactoryGirl.create(:entidade_1)
				put :update, id: @entidade, pagina: FactoryGirl.attributes_for(:entidade_1)
				response.should redirect_to [:administracao,@entidade]
			end
		end

			context "atributos inválidos" do 
				
				it "Não Atualizando atributo" do
					@entidade = FactoryGirl.create(:entidade_1) 
					put :update, id: @entidade, entidade: FactoryGirl.attributes_for(:entidade_1,:slug=>"")
					@entidade.reload
					@entidade.slug.should eq("entidade001")
				end

				it "Renderizando Action" do 
					@entidade = FactoryGirl.create(:entidade_1) 
					put :update, id: @entidade, entidade: FactoryGirl.attributes_for(:entidade_1,:slug=>"")
					response.should render_template :edit
				end
			end
	end

end
