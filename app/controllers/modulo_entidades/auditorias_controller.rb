#encoding: UTF-8

class ModuloEntidades::AuditoriasController < ApplicationController

	before_filter :valid_payment
	before_filter :verifica_se_esta_logado, except: [:edit, :update]
	before_filter :verifica_se_o_usuario_escolheu_uma_unidade, except: [:edit, :update]


	def index
		params[:pesquisa] ||= {}
		@auditorias = Auditoria.pesquisa(current_unidade.id, params[:pesquisa])
													 .page(params[:page])
													 .per(15)
	end

	def show
		@auditoria = Auditoria.find(params[:id])
	end

	def new
		@auditoria = Auditoria.new
	end

	def create
		@auditoria = Auditoria.new
		@auditoria.unidade = current_unidade
		@auditoria.checklist = current_unidade.retorna_checklist_ativo
		@auditoria.cliente = Cliente.cria_ou_recupera(current_unidade.id, params[:cliente])
		if @auditoria.save
			redirect_to [:entidade, :auditorias], notice: 'Auditoria liberada com sucesso!'
		else
			render :new
		end
	end

	def edit
		@auditoria = Auditoria.find(params[:id])
	end

	def update
		@auditoria = Auditoria.find(params[:id])
		@retorno = @auditoria.salvar_respostas(params)
		# if @retorno.first 
		# 	@auditoria.notifica_responsaveis_do_checklist
		# end
	end

	def iniciar_pesquisa
		@retorno = Auditoria.retorna_auditoria_para_ser_respondida
	end

	def retorna_clientes
    @retorno = []
    configuracao = Configuracao.first

    @clientes_ids = ErpFatFrenteCaixa.where('REVENDA = ?' configuracao.revenda)
    														 		 .where('SITUACAO = ?', 'P')
    														 		 .where('CAIXA IN(3)')
    														 		 .where('ORIGEM = ?', configuracao.origem)
    														 		 .limit(10)
    														 		 .pluck(:cliente_emissao_nf)
    														 		 .uniq

    @clientes = ErpCliente.where('CLIENTE IN(?)', @clientes_ids) rescue nil if @clientes_ids.present?

    if @clientes.present?
			@clientes.each do |objeto|
        @retorno << { label: "(#{objeto.cliente} - #{objeto.nome}",
                      value: "(#{objeto.cliente} - #{objeto.nome}",
                      id: objeto.id,
                      # cpf_cnpj: objeto.cpf_cnpj,
                      cpf_cnpj: nil,
                      codigo: objeto.cliente,
                      nome: objeto.nome
                    }
      end
    else
      @retorno << { label: 'Cliente não encontrado!', value: 'Cliente não encontrado!', id: nil }
    end
    respond_to do |format|  
      format.json { render json: @retorno.to_json }
    end
  end

end
