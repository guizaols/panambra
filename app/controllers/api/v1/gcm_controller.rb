class Api::V1::GcmController < Api::V1Controller


	def show
		@usuario_id = params[:usuario_id]
		@usuario = Usuario.find @usuario_id
		@usuario.gcm = params[:gcm]
		respond_to do |format|
			if @usuario.save
    			format.json { render json: { resultado: true }}
    		else
				format.json { render json: { resultado: false }}
    		end
    	end
	end
end
