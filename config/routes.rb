Template::Application.routes.draw do 

  # get '/delayed_job' => DelayedJobWeb, anchor: false

  namespace :api do
    namespace :v1 do
      post "authentications" => "authentications#create"
      post "nao_conformidades" => "nao_conformidades#index"
      post "nao_conformidade" => "nao_conformidades#show"
      post "finalizar" => "nao_conformidades#finalizar"
      post "escalonar" => "nao_conformidades#escalonar"
      post "gcm" => "gcm#show"
    end
  end

  ### PASSOS DA AUDITORIA
  match 'primeiro_passo' => 'home#primeiro_passo'
  match 'pesquisa_ordem_servico' => 'home#pesquisa_ordem_servico'
  match 'segundo_passo' => 'home#segundo_passo'
  match 'iniciar_auditoria' => 'home#iniciar_auditoria'
  match 'ultimo_passo' => 'home#ultimo_passo'

  namespace :administracao do
    devise_for :usuarios, controllers: { sessions: 'administracao/sessions',
                                         registrations: 'administracao/registrations' }
    root to: 'home#index'
    resources :entidades do 
      member do 
        get :change_status
      end
    end

    resources :administradores do 
       member do 
        get :change_status
      end
    end
  end

  match ':entidade_slug' => 'home#index', as: :entidade, module: :modulo_entidades
  scope ':entidade_slug', as: :entidade, module: :modulo_entidades do
    match 'acessar' => 'home#index'
    namespace :administracao do

      resources :unidades do
        member do
          get :change_status
        end
        collection do 
          get  :escolher_unidade
          post :acessando_unidade
          get  :sair_unidade
        end
      end

      resources :perfils do
        member do
          get :change_status
        end
      end

      resources :configuracoes

      root to: 'home#index'
    end

    resources :nao_conformidades

    resources :checklists do
      member do
        get :change_status
      end
      
      collection do 
        post :edit_questao_ajax
        post :edit_categoria_ajax
        post :nova_acao 
        post :altera_situacao_categoria
        post :altera_situacao_questao
        post :detalhe_questao
      end
      resources :questoes do 
        collection do 
          post :nova_categoria_questao
          post :nova_subcategoria_questao
          post :carrega_subcategoria
          post :nova_questao
          post :carrega_form_questao
          post :atualiza_categoria
          post :atualiza_item_verificacao
          post :cria_acao
          post :carrega_alternativa
          get :inserir_imagem
          post :upload_imagem
        end
      end
    end


    resources :auditorias do
      collection do
        get  :iniciar_pesquisa
        post :retorna_clientes
      end
    end


    resources :clientes do
      collection do
        post :autocomplete_by_nf
      end
    end


    resources :usuarios do
      member do
        get :change_status
      end
    end

    resources :relatorios do
      collection do
        get :pesquisas_respondidas
        get :pesquisas_detalhadas
        get :dashboards
        get :relatorio_ordem_servicos
      end
    end

    root to: 'home#index'
  end
  
  root to: 'home#index'
end
