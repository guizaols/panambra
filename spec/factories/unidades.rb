#encoding: UTF-8

FactoryGirl.define do

  factory :unidade_1, class: Unidade do
    id 1
    nome 'Unidade 001'
    slug 'unidade001'
    situacao 1
   # entidade_id 1
     association :entidade, factory: :entidade_1
  end

  factory :unidade_1_invalida, class: Unidade do
    id 1
    nome 'Unidade 001'
    slug 'unidade001'
    situacao 1
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :unidade_2, class: Unidade do
    id 2
    nome 'Unidade 002'
    slug 'unidade002'
    situacao 2
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :unidade_2_slug_invalido, class: Unidade do
    id 2
    nome 'Unidade 002'
    slug 'Unidádã'
    situacao 2
    entidade_id 1
    # association :entidade, factory: :entidade_1
  end

  factory :unidade_3, class: Unidade do
    id 3
    nome 'Unidade 003'
    slug 'unidade003'
    situacao 1
    entidade_id 2
    # association :entidade, factory: :entidade_2
  end

   factory :unidade_4, class: Unidade do
    id 1
    nome 'Unidade 004'
    slug 'unidade004'
    situacao 2
    #entidade_id 1
     association :entidade, factory: :entidade_1
  end
end

 
