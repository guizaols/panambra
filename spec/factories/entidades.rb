FactoryGirl.define do
    factory :entidade_1,class: Entidade do
        id 1
        nome "Entidade 001"
        slug "entidade001"
        situacao 1
    end

    factory :entidade_1_1_invalida,class: Entidade do
        id 1
        nome "Entidade 001"
        slug "entidade001"
        situacao 1
    end

    factory :entidade_2,class: Entidade do
        id 2
    	nome "Entidade 002"
        slug "entidade002"
        situacao 2
    end

    factory :entidade_3,class: Entidade do
        id 3
        nome "Entidade 003"
        slug "entidade003"
        situacao 1
    end
end