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

  def autocomplete_by_nf
    @retorno     = []
    @nota_fiscal = ErpNotaFiscal.where('EMPRESA = ?', 1)
                                .where('REVENDA = ?', 1)
                                .where('TIPO_TRANSACAO IN(?)', ['V21', 'G21', '021', 'U21'])
                                .where('NUMERO_NOTA_FISCAL = ?', params[:pesquisa])
                                .first rescue nil

    @clientes = ErpCliente.where('CLIENTE = ?', @nota_fiscal.cliente) rescue nil if @nota_fiscal.present?
    if @clientes.present?
      @clientes.each do |objeto|
        @retorno << { label: "(#{@nota_fiscal.numero_nota_fiscal}) #{objeto.cliente} - #{objeto.nome}",
                      value: "(#{@nota_fiscal.numero_nota_fiscal}) #{objeto.cliente} - #{objeto.nome}",
                      id: objeto.id,
                      # cpf_cnpj: objeto.cpf_cnpj,
                      cpf_cnpj: nil,
                      codigo: objeto.cliente,
                      nome: objeto.nome
                    }
      end
    else
      @retorno << { label: 'Nota fiscal não encontrada!', value: 'Nota fiscal não encontrada!', id: nil }
    end
    respond_to do |format|  
      format.json { render json: @retorno.to_json }
    end
  end

end
