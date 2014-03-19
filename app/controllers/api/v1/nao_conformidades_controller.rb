class Api::V1::NaoConformidadesController < Api::V1Controller


	def index
		@usuario_id = params[:usuario_id]
		@nao_conformidades = NaoConformidade.where('(status = ? AND usuario_id = ?) OR
																								(status = ? AND usuario_delegado_id = ?)',
																							 NaoConformidade::CRIADO, @usuario_id,
																							 NaoConformidade::ESCALONADO, @usuario_id)
																				.order('data DESC')
		respond_to do |format|
			format.json do
    		render json: { nao_conformidades: @nao_conformidades.as_json(:include =>[:cliente,:item_verificacao]) }
			end
    end
	end

	def show
		@nao_conformidade = NaoConformidade.find params[:nao_conformidade_id]
		respond_to do |format|
    	format.json { render json: { usuarios: Usuario.where('situacao = ? AND unidade_id = ? AND id <> ?', Usuario::ATIVO,current_api_user.unidade_id,current_api_user.id), nao_conformidade: @nao_conformidade.as_json(:include =>[:cliente,:item_verificacao]) }}
    end
	end


	def finalizar
		@nao_conformidade = NaoConformidade.find params[:nao_conformidade_id]
		@nao_conformidade.status = NaoConformidade::FINALIZADO
		@nao_conformidade.comentarios = params[:comentarios]
		respond_to do |format|
			if @nao_conformidade.save
    			format.json { render json: { resultado: true }}
    	else
				format.json { render json: { resultado: false }}
    	end
    end
	end

	def escalonar
		@nao_conformidade = NaoConformidade.find params[:nao_conformidade_id]
		@nao_conformidade.status = NaoConformidade::ESCALONADO
		@nao_conformidade.usuario_delegado_id = params[:usuario_delegado_id]
		@nao_conformidade.data_escalonada = Date.today
		respond_to do |format|
			if @nao_conformidade.save
    		format.json { render json: { resultado: true }}
    	else
				format.json { render json: { resultado: false }}
    	end
    end
	end

end
