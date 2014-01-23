#encoding: UTF-8

require 'spec_helper'

describe Unidade do
  
	describe "Teste de validações" do

		it "Campos Obrigatórios" do 
			unidade = FactoryGirl.build(:unidade_1, nome: '', slug: '', situacao: '', entidade_id: '')
		  unidade.should_not(be_valid)
		  unidade.should have(1).error_on(:nome)
		  unidade.should have(2).error_on(:slug)
		  unidade.should have(1).error_on(:entidade)
		  unidade.errors.messages[:nome].should(include('não pode ficar em branco'))
		  unidade.errors.messages[:slug].should(include('não pode ficar em branco'))
		  unidade.errors.messages[:slug].should(include('não pode ficar em branco', 'não é válido'))
		  unidade.errors.messages[:entidade].should(include('não pode ficar em branco'))
		end

		it "Inicializar Unidade com status ATIVO" do 
			unidade = Unidade.new
			unidade.situacao.should(eq(Unidade::ATIVO))
		end

		it "Nome/Slug deve ser único por Entidade" do 
			unidade = FactoryGirl.build(:unidade_1)
			unidade_invalida = FactoryGirl.build(:unidade_1_invalida)
			unidade_invalida.should_not(be_valid)
			unidade_invalida.should(have(1).error_on(:nome))
			unidade_invalida.should(have(1).error_on(:slug))
			unidade_invalida.errors.messages[:nome].should(include('Nome igual'))
			unidade_invalida.errors.messages[:slug].should(include('Slug igual'))
		end

		it "Slug inválido" do 
			unidade = FactoryGirl.build(:unidade_2_slug_invalido)
		  unidade.should_not(be_valid)
		  unidade.should(have(1).error_on(:slug))
		end

		it "Nome/Slug devem ser menores do que 255 caracteres" do 
			unidade = FactoryGirl.build(:unidade_1)
			unidade.nome = 'nome' * 100
			unidade.slug = 'slug' * 100
			unidade.should_not(be_valid)
			unidade.should(have(1).error_on(:nome))
			unidade.should(have(1).error_on(:slug))
			unidade.errors.messages[:nome].should(include('é muito longo (máximo: 255 caracteres)'))
			unidade.errors.messages[:slug].should(include('é muito longo (máximo: 255 caracteres)'))
		end

	end


	describe "Outros Métodos" do 

		it "Situação Verbose" do 
			unidade = FactoryGirl.build(:unidade_1)
			unidade.situacao_verbose.should(eq('Ativo'))
			outra_unidade = FactoryGirl.build(:unidade_2)
			outra_unidade.situacao_verbose.should(eq('Inativo'))
		end

		it "Teste de relacionamento" do 
			unidade = FactoryGirl.build(:unidade_1)
			entidade = FactoryGirl.create(:entidade_1)
			unidade.entidade.should(eq(entidade))
		end

		it "Retorna unidades para select" do 
			unidade = FactoryGirl.create(:unidade_1)
			unidade_inativa = FactoryGirl.create(:unidade_4)
			Unidade.retorna_unidade_para_select.should eq([unidade,unidade_inativa])
		end

	end

end
