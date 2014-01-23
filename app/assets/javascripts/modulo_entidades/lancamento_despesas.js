function carrega_categoria_de_despesa_nivel_1() {
	$('#lancamento_despesa_setor_id').live('change', function() {
		$.ajax({
    	url: urlParaCategoriaDespesaNivel1,
     	dataType: 'script',
     	type: 'POST',
     	data: { setor_id: $(this).val() }
   	});
	});
}

function carrega_categoria_de_despesa_nivel_1_individual(new_or_edit, quantidade_itens_edit) {
	if(new_or_edit == 1) {
    var maior_identificador = $('#maior_identificador').val();
  	$.ajax({
     	url: urlParaCategoriaDespesaNivel1,
     	dataType: 'script',
     	type: 'POST',
     	data: {
     					setor_id: $('#lancamento_despesa_setor_id').val(),
     					individual: 1,
     					maior_identificador: (parseInt(maior_identificador, 10) + 1)
     				}
   	});
  } else {
    ordena_novos_itens();
    var maior_identificador = $('#maior_identificador').val();
    $.ajax({
      url: urlParaCategoriaDespesaNivel1,
      dataType: 'script',
      type: 'POST',
      data: {
              setor_id: $('#lancamento_despesa_setor_id').val(),
              individual: 1,
              maior_identificador: (parseInt(maior_identificador, 10))
            }
    });
  }
}

function carrega_categoria_de_despesa_nivel_2() {
  $('.despesa_nivel_1').live('change', function() {
    $.ajax({
      url: urlParaCategoriaDespesaNivel2,
      dataType: 'script',
      type: 'POST',
      data: { 
              setor_id: $('#lancamento_despesa_setor_id').val(),
              categoria_nivel_1_id: $(this).val(),
              object_name: $(this).attr('id')
            }
    });
  });
}

function carrega_categoria_de_despesa_nivel_3() {
  $('.despesa_nivel_2').live('change', function() {
    $.ajax({
      url: urlParaCategoriaDespesaNivel3,
      dataType: 'script',
      type: 'POST',
      data: { 
              setor_id: $('#lancamento_despesa_setor_id').val(),
              categoria_nivel_2_id: $(this).val(),
              object_name: $(this).attr('id')
            }
    });
  });
}

function carrega_categorias_de_despesa_no_edit() {
  $('#itens_lancamentos > input').each(function(index, input) {
    $.ajax({
      url: urlParaCategoriasDespesaTodosNiveis,
      dataType: 'script',
      type: 'POST',
      data: { 
              item_id: $('#' + $(input).attr('id')).val(),
              object_name: $(input).attr('id')
            }
    })
  });
}

function carrega_valor_total_orcamento() {
  $('.despesa_nivel_3').live('change', function() {
    $.ajax({
      url: urlParaValorTotalOrcamento,
      dataType: 'script',
      type: 'POST',
      data: { 
              setor_id: $('#lancamento_despesa_setor_id').val(),
              categoria_nivel_3_id: $(this).val(),
              object_name: $(this).attr('id')
            }
    });
  });
}

function valida_valor_previsto_e_calcula_saldo() {
  $('.valor').live('blur', function() {
    var element_id = '#' + $(this).attr('id');
    var valor_previsto = parseFloat($(this).val());
    var total_orcamento = parseFloat($(element_id).parent().prev().find('.total').val());
    if(valor_previsto > total_orcamento) {
       alert('O valor previsto é maior do que o valor total do orçamento!')
       $(this).val('');
    } else {
      var saldo_orcamento = (total_orcamento - valor_previsto).toFixed(2);
      $(element_id).parent().next().find('.saldo').val(saldo_orcamento);
    }
  });
}

function add_fields_lancamentos(link, container, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g')
  $(container).append(content.replace(regexp, new_id));
  ordena_novos_itens();
}

function remove_fields_lancamentos() {
  $('.remover').live('click', function() {
    $(this).parents().parents('tr').remove();
  	ordena_novos_itens();
  	return false;
  });
}

function ordena_novos_itens() {
  $('#itens_lancamentos > tr').each(function(index, value) {
    var numero = index + 1
    $('input:eq(0)', value).attr('data-number', numero);
    $('#maior_identificador').val(numero);
  });
}

function delete_item_lancamento() {
  $('.excluir-item').click(function() {
    if(confirm('Deseja realmente excluir este registro?')) {
      $.ajax({
        url: urlParaDeletarItens,
        dataType: 'script',
        type: 'POST',
        data: { 
                id: $(this).data('id')
              }
      })
    }
    return false
  });
}
