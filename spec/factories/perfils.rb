#encoding: UTF-8

FactoryGirl.define do
  
  factory :perfil_1, class: Perfil do
    id 1
    nome 'Perfil 001'
    situacao 1
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :perfil_1_invalido, class: Perfil do
    id 4
    nome 'Perfil 001'
    situacao 1
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :perfil_2, class: Perfil do
    id 2
  	nome 'Perfil 002'
    situacao 2
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :perfil_3, class: Perfil do
    id 3
    nome 'Perfil 003'
    situacao 1
    entidade_id 2
    # association :entidade, factory: :entidade_2
  end

end
