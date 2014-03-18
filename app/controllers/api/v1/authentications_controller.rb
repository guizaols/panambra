class Api::V1::AuthenticationsController < Api::V1Controller

  skip_before_filter :authenticate_api_user!

  def create
    @user = Usuario.where('login = ? OR email = ?', params[:login], params[:login]).first
    respond_to do |format|
      if @user.present? && @user.valid_password?(params[:password])
        format.json do
          render json: { user: @user, auth_token: @user.authentication_token }
        end
      else
        format.json do
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end
    end
  end

end
