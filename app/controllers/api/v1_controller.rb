class Api::V1Controller < ApiController

   before_filter :authenticate_api_user!

   helper_method :current_api_user
   helper_method :api_user_authenticated?

  private

    def authenticate_api_user!
      unless api_user_authenticated?
        respond_to do |format|
          format.json { head :unauthorized }
        end
      end
    end

    def current_api_user
      if params[:authentication_key]
        @users = Usuario.where(situacao:Usuario::ATIVO)
        @users = @users.where("(api_authentication_token = ? OR login = ? OR email = ?) AND tipo = ?",params[:authentication_key],params[:authentication_key],params[:authentication_key],Usuario::VENDAS).first
        unless params[:password].blank?
          @users.valid_password?(params[:password])
        else
         if @users.api_authentication_token == params[:authentication_token]
          @users
        else
          {}
         end
        end
      end
    end

    def api_user_authenticated?
      current_api_user.present?
    end

end
