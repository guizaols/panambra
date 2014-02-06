#encoding: UTF-8

class ModuloEntidades::ClientesController < ApplicationController

  before_filter :valid_payment
	before_filter :verifica_se_esta_logado
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade


	def index
		params[:pesquisa] ||= {}
		@clientes = Cliente.pesquisa(current_unidade.id, params[:pesquisa])
											 .page(params[:page])
											 .per(15)
	end

  def autocomplete_by_cpf_cnpj
    @retorno = []
    @clientes = Cliente.where('unidade_id = ? AND cpf_cnpj LIKE ?',
                               current_unidade.id, params[:pesquisa].full_like)
                        .order(:nome, :cpf_cnpj)

    if @clientes.present?
      @clientes.each do |objeto|
        @retorno << { label: "#{objeto.codigo} - #{objeto.nome}",
                      value: "#{objeto.codigo} - #{objeto.nome}",
                      id: objeto.id,
                      cpf_cnpj: objeto.cpf_cnpj,
                      codigo: objeto.codigo,
                      nome: objeto.nome
                    }
      end
    else
      @retorno << { label: 'Clientes não encontrados!', value: 'Clientes não encontrados!', id: nil }
    end
    respond_to do |format|  
      format.json { render json: @retorno.to_json }
    end
  end

end
