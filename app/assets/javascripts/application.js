/* 
 *= require jquery
 *= require jquery-ui
 *= require jquery.treeview
 *= require jquery.contextMenu
 *= require jquery.maskMoney
 *= require jquery.numeric
 *= require jquery-ui.multidatespicker
 *= require maskedinput
 *= require jquery_ujs
 *= require bootstrap
 *= require fuelux
 *= require_tree .
*/


jQuery(function($) {
  initializeDatepickers();
  initializeMultiDatepickers();
  initializeDecimalMask();
  initializeNumericMask();
  initializeTimerMask();
  initializePhoneMask();
});

/* Portuguese initialisation for the jQuery UI date picker plugin. */
jQuery(function($) {
  $.datepicker.regional['pt-BR'] = {
    closeText: 'Fechar',
    prevText: 'Anterior',
    nextText: 'Seguinte',
    currentText: 'Hoje',
    monthNames: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
    monthNamesShort: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
    dayNames: ['Domingo', 'Segunda-feira', 'Ter&ccedil;a-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'S&aacute;bado'],
    dayNamesShort: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],
    dayNamesMin: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],
    weekHeader: 'Sem',
    dateFormat: 'dd/mm/yy',
    firstDay: 0,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: '',
    changeMonth: true,
    changeYear: true,
    constrainInput: false
  };
  $.datepicker.setDefaults($.datepicker.regional['pt-BR']);

});

/// START MASCARAS
function initializeDatepickers() {
  $('.auto-datepicker').datepicker({
    language: 'pt-BR',
    format: 'dd/mm/yyyy'
  });
  $('.auto-datepicker').mask('99/99/9999');
}

function initializeMultiDatepickers() {
  $('.auto-multidatepicker').multiDatesPicker();
}

function initializeDecimalMask() {
  $('.decimal').maskMoney({
    showSymbol: false,
    decimal: '.',
    thousands: '',
    allowZero: true
  });
}

function initializeNumericMask() {
  $('.numeric').numeric({ decimal: false, negative: false });
}

function initializeTimerMask() {
  $('.timer').mask('99:99');
}

function initializePhoneMask() {
  $('.phone').mask('(99) 9999-9999?9');
}
/// END MASCARAS


$(document).ajaxStart(function() {
  $('#loading').show();
}).ajaxStop(function() {
  $('#loading').hide();
});

function desenha_view_usuario() {
	if($('#usuario_tipo').val() == '3') {
    $('#perfil').hide();
    $('#usuario_perfil_id').val('');
  } else {
    $('#perfil').show();
  }
}

function insere_elemento_filho(content_view, id) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_i', 'g')
  var content = content_view;
  $(id).append(content.replace(regexp, new_id));
  return false;
}

function link_to_add_elemento_filho(id_link, content_view, id_elemento_filho, condicao) {
  $(id_link).click(function() {
    insere_elemento_filho(content_view, id_elemento_filho);
    return false;
  });
  if(condicao == 'true') {
    insere_elemento_filho(content_view, id_elemento_filho);
  }
}
