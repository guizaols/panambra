function loadTreeViewAndContextChecklist() {
  $('#browser').treeview();
  $('.category_master').contextMenu({
    menu: 'menu_master'
  }, function(action, element) {
    loadFormCheckList(action, element);
  });
  $('.category').contextMenu({
    menu: 'menu_categories'
  }, function(action, element) {
    loadFormCheckList(action, element);
  });
  $('.question').contextMenu({
    menu: 'menu_questions'
  }, function(action, element) {
    loadFormCheckList(action, element);
  });
}

function loadFormCheckList(action, element) {
 // alert(action);
  var dialog     = '#dialog';
  var script     = false;
  var withDialog = true;
  var confirms   = false;
  var ajax       = {};

  switch(action) {

    case 'checklist_nova_questao':
          $("#form_nova_questao").dialog({title: 'Nova Questão', width: '900'});
          withDialog = false;
          break;
    case 'checklist_editar_categoria':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForChecklistEditCategoria();
          $.ajax(ajax);
          break;
    case 'checklist_edit_questao':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForChecklistEditQuestao();
          $.ajax(ajax);
          break;    
    case 'checklist_acoes':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForAcoes();
          $.ajax(ajax);
          break;
    case 'checklist_alterar_situacao_categoria':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForAlteraSituacaoCategoriaQuestao();
          if(confirm('Deseja alterar a situação deste registro?'))
            $.ajax(ajax);
          break;
    case 'checklist_alterar_situacao_questao':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForAlteraSituacaoQuestao();
          if(confirm('Deseja alterar a situação deste registro?'))
            $.ajax(ajax);
          break;
    case 'checklist_detalhes_questao':
          ajax.type = 'POST';
          ajax.data = 'id=' + element.attr('id');
          ajax.url  = urlForDetalhesDeUmaQuestao();
          $.ajax(ajax);
          break;


          
  }

}
