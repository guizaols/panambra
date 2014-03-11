#encoding: UTF-8
class ModuloEntidades::NaoConformidadesController < ApplicationController
  
  def index
    #@nao_conformidades = NaoConformidade.where("unidade_id = ? AND status = ?",current_unidade.id,NaoConformidade::CRIADO).page(params[:page])
     #                            .per(15)

@nao_conformidades = NaoConformidade.where("unidade_id = ?",current_unidade.id).page(params[:page])
                                 .per(15)

  end

  def show
    @nao_conformidade = NaoConformidade.find(params[:id])
  end

  def new
    @nao_conformidade = NaoConformidade.new
  end

  def edit
    @nao_conformidade = NaoConformidade.find(params[:id])
  end

  def create
    @nao_conformidade = NaoConformidade.new(params[:nao_conformidade])
    @nao_conformidade.status = NaoConformidade::CRIADO 
      if @nao_conformidade.save
        redirect_to @nao_conformidade, notice: 'Não Conformidade criada com sucesso!'
      else
        render action: "new"
      end
  end

  def update
    @nao_conformidade = NaoConformidade.find(params[:id])
    if @nao_conformidade.update_attributes(params[:nao_conformidade])
      redirect_to @nao_conformidade, notice: 'Não Conformidade atualizada com sucesso!'
    else
      render action: "edit"
    end
  end

  def destroy
    @nao_conformidade = NaoConformidade.find(params[:id])
    @nao_conformidade.destroy
    redirect_to nao_conformidades_url
  end

  
end
