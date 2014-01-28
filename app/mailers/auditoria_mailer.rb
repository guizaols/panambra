#encoding: UTF-8

class AuditoriaMailer < ActionMailer::Base
  
	default from: 'no-reply@devconnit.com'


	def envia_notificacao_para_responsaveis(email, respostas)
    @respostas = respostas
   	titulo = "Nova Pesquisa (#{respostas.first.auditoria.cliente.nome.upcase})"
		mail({
					to: email,
					subject: titulo
				})
	end

end
