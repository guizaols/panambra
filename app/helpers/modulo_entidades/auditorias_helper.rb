module ModuloEntidades::AuditoriasHelper

	def monta_checklist_de_auditoria(item_checklist, index)
		item_verificacao = item_checklist.item_verificacaos.first rescue nil
		numero = index + 1
		if item_verificacao.present?
			if item_verificacao.tipo == ItemVerificacao::SIM_NAO
	    	render('sim_nao', item_verificacao: item_verificacao, numero: numero)
		 	elsif item_verificacao.tipo == ItemVerificacao::SIM_NAO_TEXTO
				render('sim_nao_texto', item_verificacao: item_verificacao, numero: numero)
		 	elsif item_verificacao.tipo == ItemVerificacao::TEXTO
				render('texto', item_verificacao: item_verificacao, numero: numero)
	   	end
	  end
	end

end
