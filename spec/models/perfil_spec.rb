#encoding: UTF-8

require 'spec_helper'

describe Perfil do

  
	describe "Teste de validações" do

		it "Campos Obrigatórios" do 
		  perfil = FactoryGirl.build(:perfil_1, nome: '', permissoes: '', situacao: '', entidade_id: '')
		  perfil.should_not(be_valid)
		  perfil.should(have(1).error_on(:nome))
		  perfil.should(have(1).error_on(:entidade))
		  perfil.errors.messages[:nome].should(include('não pode ficar em branco'))
		  perfil.errors.messages[:entidade].should(include('não pode ficar em branco'))
		end

		it "Inicializar Perfil com status ATIVO" do 
			perfil = Perfil.new
			perfil.situacao.should(eq(Perfil::ATIVO))
		end

		it "Nome deve ser único por Entidade" do 
			perfil = FactoryGirl.build(:perfil_1)
			perfil_invalido = FactoryGirl.build(:perfil_1_invalido)
			perfil_invalido.should_not(be_valid)
			perfil_invalido.should(have(1).error_on(:nome))
			perfil_invalido.errors.messages[:nome].should(include('Entidade não pode ficar em branco'))
		end

		it "Nome deve ser menor do que 255 caracteres" do 
			perfil = FactoryGirl.build(:perfil_1)
			perfil.nome = 'teste' * 100
			perfil.should_not(be_valid)
			perfil.errors.messages[:nome].should(include('é muito longo (máximo: 255 caracteres)'))
		end

	end


	describe "Outros Métodos" do 

		it "Situação Verbose" do 
			perfil = FactoryGirl.build(:perfil_1)
			perfil.situacao_verbose.should(eq('Ativo'))
			outro_perfil = FactoryGirl.build(:perfil_2)
			outro_perfil.situacao_verbose.should(eq('Inativo'))
		end

		it "Teste de relacionamento" do 
			perfil = FactoryGirl.build(:perfil_1)
			entidade = FactoryGirl.create(:entidade_1)
			perfil.entidade.should(eq(entidade))
		end

	end

end
