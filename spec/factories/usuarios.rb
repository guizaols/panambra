FactoryGirl.define do
    factory :usuario_administrador_geral_do_sistema_1,class: Usuario do
    	id 1
        email "paulo.zeferino@gigaservices.com.br"
        login "paulo.zeferino"
        tipo 1
        password "pianista1987"
        password_confirmation "pianista1987"
    end

    factory :usuario_administrador_geral_do_sistema_2,class: Usuario do
    	id 2
        email "guilherme.santos@gigaservices.com.br"
        login "guilherme.santos"
        tipo 1
        password "qwe123@"
        password_confirmation "qwe123@"
    end

    factory :usuario_administrador_da_entidade_1_0,class: Usuario do
        id 3
        email "paulo.entidade001@entidade001.com.br"
        login "paulo.entidade001"
        tipo 2
        password "qwe123@"
        password_confirmation "qwe123@"
        association :entidade, factory: :entidade_1
    end

    factory :usuario_administrativo_entidade_1_1,class: Usuario do
        id 4
        email "paulo.administrativo@entidade001.com.br"
        login "paulo.administrativo"
        tipo 3
        password "qwe123@"
        password_confirmation "qwe123@"
        association :entidade, factory: :entidade_1
    end
end