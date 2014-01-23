#encoding: UTF-8
require 'spec_helper'

describe Entidade do
  

	describe "Teste de validações" do 
		it "Campos Obrigatórios" do 
			entidade = FactoryGirl.build(:entidade_1, :nome => "", :slug=>"",:situacao=>"")
		    entidade.should_not be_valid
		    entidade.should have(1).error_on(:nome)
		    entidade.should have(1).error_on(:slug)
		end

		it "Inicializar Entidade com status ATIVO" do 
			@entidade = Entidade.new
			@entidade.situacao.should eq(Entidade::ATIVO)
		end

		it "Slug/Nome deve ser único" do 
			entidade = FactoryGirl.create(:entidade_1)
			entidade_invalida = FactoryGirl.build(:entidade_1_1_invalida)
			entidade_invalida.should_not be_valid
			entidade_invalida.should have(1).error_on(:slug)
			entidade_invalida.should have(1).error_on(:nome)
		end
	end

	describe "Outros Métodos" do 

		it "Situação Verbose" do 
			entidade =FactoryGirl.build(:entidade_1)
			entidade.situacao_verbose.should eq("Ativo")
			outra_entidade = FactoryGirl.build(:entidade_2)
			outra_entidade.situacao_verbose.should eq("Inativo")
		end

		it "Teste de relacionamento" do 
			entidade =FactoryGirl.build(:entidade_1)
			usuario = FactoryGirl.create(:usuario_administrador_da_entidade_1_0)
			entidade.usuarios.should eq([usuario])
		end

		it "Testa o método administrador_entidade" do
			entidade =FactoryGirl.build(:entidade_1)
			usuario = FactoryGirl.create(:usuario_administrador_da_entidade_1_0)
			entidade.administrador_entidade.id.should eq(usuario.id)
		end

		it "Testa o método retorna situacao para select" do 
			Entidade.retorna_situacao_para_select.should eq([["Ativo",Entidade::ATIVO],["Inativo",Entidade::INATIVO]])
		end

	end


end
