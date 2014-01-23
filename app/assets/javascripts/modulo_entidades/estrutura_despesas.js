function loadTreeViewAndContextEstruturaDespesa() {
  $('#browser').treeview();
  $('.folder').contextMenu({
    menu: 'estrutura_folders'
  }, function(action, element) {
    loadForm(action, element);
  });
  $('.folder_master').contextMenu({
    menu: 'estrutura_folder_master'
  }, function(action, element) {
    loadForm(action, element);
  });
}

function loadForm(action, element) {
  var dialog     = '#dialog';
  var script     = false;
  var withDialog = true;
  var confirms   = false;
  var ajax       = {};

  switch(action) {
    case 'estrutura_new':
      // $('#modal_title').html('Nova Estrutura de Despesa');
      ajax.type = 'POST';
      if(element.attr('id') > 0) {
        ajax.data = 'estrutura_despesa_id=' + element.attr('id') + '&nivel=' + element.data('nivel');
      }
      if(element.data('nivel') == 3) {
        withDialog = false;
      }
      ajax.url  = urlForEstruturaNew();
      break;
    case 'estrutura_edit':
      ajax.type = 'POST';
      ajax.data = 'id=' + element.attr('id');
      ajax.url  = urlForEstruturaEdit();
      break;
    case 'estrutura_show':
      ajax.type = 'POST';
      ajax.data = 'id=' + element.attr('id');
      ajax.url  = urlForEstruturaShow();
      break;
    case 'estrutura_change_status':
      script     = true;
      withDialog = false;
      confirms   = true;
      ajax.type  = 'POST';
      ajax.data  = 'id=' + element.attr('id');
      ajax.url   = urlForEstruturaChangeStatus();
      break;
    case 'estrutura_destroy':
      script     = true;
      withDialog = false;
      confirms   = true;
      ajax.type  = 'POST';
      ajax.data  = 'id=' + element.attr('id');
      ajax.url   = urlForEstruturaDestroy();
      break;
  }
  if(script) {
    ajax.dataType = 'script';
  }
  if(withDialog) {
    ajax.success = function(data) {
      $(dialog).html(data);
      $(dialog).modal('show');
    };
  }
  if(confirms) {
    if (confirm('Deseja alterar a situação deste registro?')) {
      $.ajax(ajax);
    }
  } else {
    $.ajax(ajax);
  }

}
