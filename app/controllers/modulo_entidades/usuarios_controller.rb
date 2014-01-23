#encoding: UTF-8

class ModuloEntidades::UsuariosController < ApplicationController

	before_filter :verifica_se_esta_logado


	def index
		params[:pesquisa] ||= {}
		@usuarios = Usuario.pesquisa(current_unidade.id, params[:pesquisa]).page(params[:page]).per(15)
	end

	def new
		@usuario = Usuario.new
	end

	def create
		@usuario = Usuario.new(params[:usuario])
		@usuario.unidade = current_unidade
		if @usuario.save
			redirect_to [:entidade, @usuario], notice: 'Usuário cadastrado com sucesso!'
		else
			render action: 'new'
		end
	end

	def show
		@usuario = Usuario.find(params[:id])
		@usuario_pontos_de_venda = UsuarioPontoDeVenda.retorna_pontos_de_venda_do_usuario(@usuario)
	end

	def edit
		@usuario = Usuario.find(params[:id])
	end

	def update
		@usuario = Usuario.find(params[:id])
		@usuario.unidade = current_unidade
		if @usuario.update_attributes(params[:usuario])
			redirect_to [:entidade, @usuario], notice: 'Usuário atualizado com sucesso!'
		else
			render action: 'edit'
		end
	end

	def change_status
		@usuario = Usuario.find(params[:id])
		if @usuario.situacao == Usuario::ATIVO
			@usuario.situacao = Usuario::INATIVO
		else
			@usuario.situacao = Usuario::ATIVO
		end
		@usuario.save
		redirect_to [:entidade, :usuarios], notice: 'Situação alterada com sucesso!'
	end

	def pesquisa_para_autocomplete
		@retorno = []
		@setor = Setor.find(params[:setor_id])
		@usuarios = Usuario.where('situacao = ? AND setor_id = ? AND (nome ILIKE ? OR login ILIKE ?)',
															Usuario::ATIVO, @setor.id, params[:pesquisa].full_like, params[:pesquisa].full_like)
		@usuarios.each do |objeto|
			@retorno << { label: objeto.nome, value: objeto.nome, id: objeto.id }
		end
		respond_to do |format|  
      format.json {render json: @retorno.to_json}
    end
	end

	def pesquisa_usuarios_vendas_para_autocomplete
		@retorno = []
		@usuarios = Usuario.where('situacao = ? AND tipo = ? AND nome ILIKE ?',
															Usuario::ATIVO, Usuario::CAIXA, params[:pesquisa].full_like)
		@usuarios.each do |objeto|
			@retorno << { label: objeto.nome, value: objeto.nome, id: objeto.id }
		end
		respond_to do |format|
      format.json {render json: @retorno.to_json}
    end
  end

	def pesquisa_usuarios_para_autocomplete
		@retorno = []
		@usuarios = Usuario.by_unidade_id(current_unidade.id)
											 .where('situacao = ? AND tipo IN(?) AND (nome ILIKE ? OR login ILIKE ?)',
											 				Usuario::ATIVO, [Usuario::CLIENTE, Usuario::CAIXA, Usuario::ADMINISTRADOR_UNIDADE],
											 				params[:pesquisa].full_like, params[:pesquisa].full_like)
		@usuarios_entidade = Usuario.by_entidade_id(current_unidade.entidade_id)
																.where('situacao = ? AND tipo = ? AND (nome ILIKE ? OR login ILIKE ?)',
											 									Usuario::ATIVO, Usuario::ADMINISTRADOR_ENTIDADE,
											 									params[:pesquisa].full_like, params[:pesquisa].full_like)
		(@usuarios + @usuarios_entidade).sort_by(&:nome).each do |usuario|
			@retorno << { label: usuario.nome, value: usuario.nome, id: usuario.id }
		end
		respond_to do |format|  
      format.json { render json: @retorno.to_json }
    end
	end

	def vincula_pdv
		@usuario_ponto_de_venda = UsuarioPontoDeVenda.where('usuario_id = ? AND ponto_de_venda_id = ?',
																												params[:usuario_id], params[:ponto_de_venda_id])
		if params[:operacao].to_i == 1
			UsuarioPontoDeVenda.create!({
																	 ponto_de_venda_id: params[:ponto_de_venda_id],
																	 usuario_id: params[:usuario_id]
																	})
			render json: "alert('Ponto de Venda vinculado com sucesso!');"
		else
			unless @usuario_ponto_de_venda.blank?
				@usuario_ponto_de_venda.first.destroy
				render json: "alert('Ponto de Venda excluído com sucesso!');"
			end
		end
	end

end
