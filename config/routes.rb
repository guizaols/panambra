Template::Application.routes.draw do 

  get '/delayed_job' => DelayedJobWeb, anchor: false

  namespace :api do
    namespace :v1 do
      post "log_acra" => "acra_logs#create"
      post "authentications" => "authentications#create"
      post "agendas" => "agendas#getAgendas"
      post "respostas" => "respostas#create"
    end
  end

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

  match ":entidade_slug" => "home#index", as: :entidade, module: :modulo_entidades
  scope ":entidade_slug", as: :entidade, module: :modulo_entidades do
    match "acessar" => "home#index"
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
      root to: 'home#index'
    end


    resources :tipo_compromissos do 
      member do 
        get :change_status
      end
    end


    resources :categoria_equipamento_ponto_de_vendas do 
      member do 
        get :change_status
      end
    end


    resources :grupo_produtos do 
       member do 
          get :change_status
        end
      resources :subgrupo_produtos do 
        member do 
          get :change_status
        end
      end
    end


    resources :setores do
      member do
        get :change_status
      end
    end


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
        end
      end
    end


    resources :produtos do
      member do
        get :change_status
      end
      collection do 
        post :retorna_subgrupos
      end
    end


    resources :orcamentos do 
      member do 
        get :change_status
        post :novo_lancamento_analitico
        post :novo_lancamento_sintetico
        post :carrega_categoria_despesa_nivel_2
        post :carrega_categoria_despesa_nivel_3
        post :carrega_categoria_despesa_nivel_3_sintetica
        post :carrega_categoria_despesa_nivel_2_sintetica
        post :carrega_usuarios_do_setor_sintetica
        post :exclui_lancamento_sintetico
        post :editar_lancamento_sintetico
        post :exclui_lancamento_analitico
        post :editar_lancamento_analitico
      end
    end
 

    resources :franqueados do
      member do
        get :change_status
      end
      collection do
        get :exportar
        post :exclui_telefone
        post :exclui_endereco
        post :pesquisa_para_autocomplete
      end
    end


    resources :estoques do
      member do
        get :change_status
      end
      collection do 
        post :pesquisa_para_autocomplete
        post :retorna_subgrupos
      end
    end


    resources :vendas do
      member do
        get :change_status
      end
      collection do 
        post :pesquisa_para_autocomplete
        post :retorna_subgrupos
        post :pesquisa_funcionario_para_autocomplete
      end
    end


    resources :usuarios do
      member do
        get :change_status
      end
      collection do 
        post :pesquisa_para_autocomplete
        post :pesquisa_usuarios_para_autocomplete
        post :pesquisa_usuarios_vendas_para_autocomplete
        post :vincula_pdv
      end
    end
    

    resources :estrutura_despesas do
      collection do
        post :show_ajax
        post :new_ajax
        post :create_ajax
        post :edit_ajax
        post :change_status_ajax
        post :destroy_ajax
      end
    end


    resources :ponto_de_vendas do
      member do
        get :change_status
        post :upload_photo
      end
      collection do
        get :exportar
        post :exclui_telefone
        post :exclui_endereco
      end

      resources :equipe_ponto_de_vendas do
        collection do 
          post :pesquisa_para_autocomplete
        end
        member do 
          get :change_status
        end
      end
      
      resources :plano_de_acoes do
        member do 
          get :change_status
          get :new_agenda
          post :create_agenda
        end
      end

      resources :franqueado_ponto_de_vendas do
        member do 
          get :change_status
        end
      end

      resources :equipamentos
      resources :metas
    end


    resources :agendas do
      member do
        get  :carregar_finalizar
        post :finalizar
        get  :exportar_compromisso
      end
      collection do
        post :pesquisa_agendas
        post :pesquisa_para_autocomplete
      end
    end


    resources :lancamento_despesas do
      collection do
        post :delete_item
        post :carrega_categoria_despesa_nivel_1
        post :carrega_categoria_despesa_nivel_2
        post :carrega_categoria_despesa_nivel_3
        post :carrega_categorias_despesas_todos_niveis
        post :carrega_valor_total_orcamento
      end
    end

    resources :prestacao_contas

    resources :importacoes do
      member do
        get :executar_importacao
        get :download_log
      end
    end

    root to: 'home#index'
  end
  root to: 'home#index'
end
