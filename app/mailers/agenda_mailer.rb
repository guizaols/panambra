#encoding: UTF-8

class AgendaMailer < ActionMailer::Base

  default from: 'no-reply@devconnit.com'

	def envia_emails_para_participantes(agenda)
    destinatarios = []
    @agenda = agenda
    destinatarios = @agenda.emails_para_envio
    if destinatarios.present?
    	titulo = "Novo Compromisso (#{agenda.titulo})"
			mail({
						to: destinatarios,
						subject: titulo
					})
		end
	end

end
