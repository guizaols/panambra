#encoding: UTF-8

class Relatorio < ActiveRecord::Base

	def self.pesquisas_respondidas(unidade_id, params)
		params = params.dup
		data_inicial = params[:data_inicial] rescue nil
		data_final = params[:data_final] rescue nil
		checklist_id = params[:checklist_id] rescue nil

		if !checklist_id.blank? && !data_final.blank? && !data_inicial.blank?
			auditorias = Auditoria.where("checklist_id = ?",checklist_id)
			auditorias = auditorias.where("DATE(created_at) between ? AND ?",data_inicial.to_date, data_final.to_date)
			return auditorias
		else
			return []
		end
	end

end
