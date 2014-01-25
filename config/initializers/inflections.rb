# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:


ActiveSupport::Inflector.inflections do |inflect|
  # inflect.acronym 'RESTful'
	inflect.irregular 'setor', 'setores'
	inflect.irregular 'administrador', 'administradores'
	inflect.irregular 'comum', 'comuns'
	inflect.irregular 'meta', 'metas'
	inflect.irregular 'item_meta', 'item_metas'
	inflect.irregular 'galeria_imagem', 'galeria_imagens'
	inflect.irregular 'acao', 'acoes'
	inflect.irregular 'prestacao_conta', 'prestacao_contas'
	inflect.irregular 'importacao', 'importacoes'
	inflect.irregular 'auditoria', 'auditorias'
	inflect.irregular 'resposta', 'respostas'
end
