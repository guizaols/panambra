#encoding: UTF-8

class ApplicationController < ActionController::Base
  
  protect_from_forgery

  helper_method :current_user
  helper_method :current_entidade
  helper_method :current_unidade
  helper_method :usuario_logado?


  def after_sign_in_path_for(resource)
    usuario = resource 
    if administracao_usuario_signed_in?
      case usuario.tipo
        when Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA
          [:administracao, :root]
        when Usuario::ADMINISTRADOR_ENTIDADE
          [:entidade, :administracao, :root]
        when Usuario::ADMINISTRADOR_UNIDADE
          session[:unidade] = usuario.unidade
          entidade_root_path(usuario.unidade.entidade.slug)
        when Usuario::CAIXA
          session[:unidade] = usuario.unidade
          entidade_root_path(usuario.unidade.entidade.slug)
        when Usuario::VENDAS
          session[:unidade] = usuario.unidade
          entidade_root_path(usuario.unidade.entidade.slug)
      end
    end
  end

  def after_sign_out_path_for(resource)
    session[:unidade] = nil
  	[:administracao, :usuario, :session]
  end


  private

    def verifica_se_o_usuario_eh_administrador_do_sistema
      if current_user.present?
        if current_user.tipo != Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA
          flash[:error] = 'Você não possui permissão para acessar este módulo!'
          if current_user.tipo == Usuario::ADMINISTRADOR_ENTIDADE
            redirect_to [:entidade, :administracao, :root]
          end
        end
      else
        flash[:error] = 'É preciso estar logado para acessar este módulo!'
        redirect_to [:administracao, :root]
      end
    end

    def verifica_se_o_usuario_eh_administrador_de_entidade
      if current_user.present?
        if current_user.tipo != Usuario::ADMINISTRADOR_ENTIDADE
          flash[:error] = 'Você não possui permissão para acessar este módulo!'
          redirect_to [:administracao, :root]
        end
      else
        flash[:error] = 'É preciso estar logado para acessar este módulo!'
        redirect_to [:administracao, :root]
      end
    end

    def verifica_se_o_usuario_escolheu_uma_unidade
      if session[:unidade].blank?
        flash[:error] = 'Você não possui permissão para acessar este módulo!'
        redirect_to [:administracao, :root]
      end
    end

    def verifica_se_esta_logado
      if current_user.blank?
        flash[:error] = 'É preciso estar logado para acessar este módulo!'
        redirect_to [:administracao, :root]
      end
    end

    def current_user
      @current_user ||= current_administracao_usuario if administracao_usuario_signed_in?
    end

    def current_unidade
      @current_unidade ||= session[:unidade].blank? ? nil : session[:unidade]
    end

    def current_entidade
      if administracao_usuario_signed_in? && current_administracao_usuario.entidade.present?
        @current_entidade ||= current_administracao_usuario.entidade
      elsif @current_entidade.blank? && current_user.present?
        @current_entidade ||= current_user.unidade.entidade 
      end
    end

    def usuario_logado?
      current_user.present?
    end

    def default_url_options(options = {})
      if administracao_usuario_signed_in?
        if current_administracao_usuario.entidade.present?
          { entidade_slug: current_administracao_usuario.entidade.slug }
        elsif current_user.entidade.present?
          { entidade_slug: current_user.unidade.entidade.slug }
        else
          {}
        end
      else
        {}
      end
    end

    def valid_payment
      payment_date = Date.new(2014, 03, 31)
      if Date.today > payment_date
        flash[:error] = 'Não é possível acessar o sistema. Contate o administrador da plataforma!'
        redirect_to [:administracao, :root]
      end
    end
  
end
