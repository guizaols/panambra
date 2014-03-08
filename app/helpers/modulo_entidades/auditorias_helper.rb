module ModuloEntidades::AuditoriasHelper

	def monta_checklist_de_auditoria(item_verificacao, index)
		if item_verificacao.present?
			if item_verificacao.tipo == ItemVerificacao::SIM_NAO
	    	render('sim_nao', item_verificacao: item_verificacao, numero: index)
		 	elsif item_verificacao.tipo == ItemVerificacao::SIM_NAO_TEXTO
				render('sim_nao_texto', item_verificacao: item_verificacao, numero: index)
		 	elsif item_verificacao.tipo == ItemVerificacao::TEXTO
				render('texto', item_verificacao: item_verificacao, numero: index)
			elsif item_verificacao.tipo == ItemVerificacao::ESCALA
				render('escala', item_verificacao: item_verificacao, numero: index)
	   	end
	  end
	end

end
