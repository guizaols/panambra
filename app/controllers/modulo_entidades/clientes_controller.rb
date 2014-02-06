#encoding: UTF-8

class ModuloEntidades::ClientesController < ApplicationController

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

    p @ultimo_numero

    @nota_fiscal = ErpNotaFiscal.where('NUMERO_NOTA_FISCAL = ?', params[:pesquisa])
    @clientes = ErpCliente.where('CLIENTE = ?', @nota_fiscal.cliente) rescue nil

    #p @nota_fiscal
    #p @clientes

    if @clientes.present?
      @clientes.each do |objeto|
        @retorno << { label: "#{objeto.cliente} - #{objeto.nome}",
                      value: "#{objeto.cliente} - #{objeto.nome}",
                      id: objeto.id,
                      # cpf_cnpj: objeto.cpf_cnpj,
                      codigo: objeto.cliente,
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
