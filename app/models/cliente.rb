#encoding: UTF-8

class Cliente < ActiveRecord::Base

  attr_accessible :codigo
  attr_accessible :cpf_cnpj
  attr_accessible :nome
  attr_accessible :unidade_id

  has_many :auditorias, dependent: :destroy

  validates :cpf_cnpj, uniqueness: { case_sensitive: false, scope: [:unidade_id]},
                    	 length: { maximum: 20 },
                       allow_nil: true
  validates :codigo, presence: true,
                     uniqueness: { case_sensitive: false, scope: [:unidade_id] }

  scope :by_unidade_id, lambda { |unidade_id| where(unidade_id: unidade_id) }
 

  def self.pesquisa(unidade_id, params)
    configuracao = Configuracao.first
    clientes = Cliente.by_unidade_id(unidade_id)
    clientes = clientes.where('codigo <> ?', configuracao.cliente_espontaneo)
    clientes = clientes.where('nome LIKE ? OR codigo LIKE ? OR cpf_cnpj LIKE ?',
    													 params[:pesquisa].full_like, params[:pesquisa].full_like,
    													 params[:pesquisa].full_like) if params[:pesquisa].present?
    clientes = clientes.order(:nome, :codigo, :cpf_cnpj)
  end

### NÃO É MAIS USADO
  # def self.cria_ou_recupera_cliente_comum(unidade_id, params)
  #   cliente = Cliente.by_unidade_id(unidade_id)
  #                    .where(codigo: params[:codigo].strip)
  #                    .first rescue nil
  #   if cliente.blank?
  #     cliente = Cliente.new({
  #       codigo: (params[:codigo].strip rescue nil),
  #       nome: (params[:nome].strip rescue nil),
  #       cpf_cnpj: (params[:cpf_cnpj].strip rescue nil),
  #       unidade_id: unidade_id
  #     })
  #     unless cliente.save
  #       cliente = nil
  #     end
  #   end
  #   cliente
  # end


  # def self.cria_ou_recupera_cliente_espontaneo(unidade_id)
  #   configuracao = Configuracao.first
  #   cliente = Cliente.by_unidade_id(unidade_id)
  #                    .where(codigo: configuracao.cliente_espontaneo.to_s)
  #                    .first rescue nil
  #   if cliente.blank?
  #     cliente = Cliente.new({
  #       codigo: configuracao.cliente_espontaneo,
  #       nome: 'CLIENTE ESPONTÂNEO',
  #       unidade_id: unidade_id
  #     })
  #     unless cliente.save
  #       cliente = nil
  #     end
  #   end
  #   cliente
  # end
### NÃO É MAIS USADO

end
