#encoding: UTF-8

module ApplicationHelper

  def error_class_for(resource, key)
    resource.respond_to?(:errors) && resource.errors.has_key?(key) ? 'error' : nil
  end

  def error_info_for(resource, key)
    resource.respond_to?(:errors) && resource.errors.has_key?(key) ? "<span class=\"help-inline\">#{resource.errors[key].first}</span>".html_safe : nil
  end

  def show_unless_blank(label, valor)
    "<dt>#{label}</dt><dd>#{valor}</dd>".html_safe unless valor.blank?
  end

  def carrega_partial_menu
    case current_user.tipo
    when Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA
      'layouts/administrador_sistema'
    when Usuario::ADMINISTRADOR_ENTIDADE;
      if current_unidade.blank?
        'layouts/usuario_entidade'
      else
        'layouts/usuario_unidade'  
      end
    when Usuario::VENDAS
      'layouts/usuario_unidade'
    when Usuario::ADMINISTRADOR_UNIDADE
       'layouts/usuario_unidade'  
    when Usuario::CAIXA
      'layouts/usuario_unidade'
    end
  end

  def error_messages(object)
  	html = ''
    if object.errors.any?
    	html = "<div class='alert alert-error fade in'>
                <strong>Por favor, verifique abaixo os campos com problemas:
      					<a class='close' data-dismiss='alert' href='#''>&times;</a>
        					#{pluralize(object.errors.count, 'ERRO ENCONTRADO', 'ERROS ENCONTRADOS')}
      					</strong>
      					<div class='box_content'>
                <ul>"
			object.errors.full_messages.each do |msg|
      	html << "<li>#{msg}</li>"
      end
      html << "</ul></div></div>"
  	end
  	html.html_safe
  end

  def loading_image_tag(id, classe = false)
    image_tag('ajax-loader.gif', id: id, class: classe, style: 'display: none;')
  end

  def monta_ramos(estrutura_despesa)
    @estrutura_despesa = estrutura_despesa
    @filhos = @estrutura_despesa.estrutura_despesas
    render('estrutura')
  end

  def monta_ramos_checklist(item_checklist)
    @item_checklist = item_checklist
    @subcategorias = @item_checklist.item_checklists
    @questoes = item_checklist.item_verificacaos #if item_checklist.item_checklist_id.present?
    render('item_checklist')
  end

  def monta_ramos_checklist_questoes(item_checklist_sub)
    @item_checklist_sub = item_checklist_sub
    @questoes = @item_checklist_sub.item_verificacaos
    render('questoes')
  end

  def grupos_for_metas
    GrupoProduto.joins(:subgrupo_produtos)
                .where(unidade_id: current_unidade.id, situacao: GrupoProduto::ATIVO)
                .order(:nome)
                .uniq
  end

  def link_to_add_fields_lancamentos(name, f, container, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to_function(name, "add_fields_lancamentos(this, \"#{container}\", \"#{association}\", \"#{escape_javascript(fields)}\"); return false;", options)
  end



### MÉTODOS FOR SELECT

  def perfis_for_select_by_entidade(id)
    perfis = current_entidade.perfils
    perfis = perfis.where('(id <> ?)', id) if id.present?
    perfis = perfis.order(:nome)
    perfis.map { |perfil| [perfil.nome, perfil.id] }
  end

  def cargos_for_select
    [
      ['Gerente', EquipePontoDeVenda::GERENTE],
      ['Supervisor', EquipePontoDeVenda::SUPERVISOR],
      ['Vendedor', EquipePontoDeVenda::VENDEDOR]
    ]
  end

  def tipos_compromisso_for_select
    tipos = current_unidade.tipo_compromissos.order(:nome)
    tipos.map { |tipo| [tipo.nome, tipo.id] }
  end

  def tipos_pdv_for_select
    PontoDeVenda.retorna_tipo_para_select(current_unidade.id)
  end

  def setor_for_select
    if current_user.eh_usuario_comum?
      if Orcamento.where(situacao: Orcamento::ATIVO, setor_id: current_user.setor_id, ano: Date.today.year).any?
        [[current_user.setor.nome, current_user.setor.id]]
      else
        []
      end
    else
      current_unidade.orcamentos
                     .where(situacao: Orcamento::ATIVO, ano: Date.today.year)
                     .collect(&:setor)
                     .sort
                     .map { |setor| [setor.nome, setor.id] }
    end
  end

  def funcionario_for_select
    if current_user.eh_usuario_comum?
      [[current_user.nome, current_user.id]]
    else
      current_unidade.usuarios
                     .where(situacao: Usuario::ATIVO, tipo: [Usuario::VENDAS, Usuario::CAIXA])
                     .order(:nome)
                     .map { |usuario| [usuario.nome, usuario.id] }
    end
  end

end
