require 'spec_helper'

describe "nao_conformidades/edit" do
  before(:each) do
    @nao_conformidade = assign(:nao_conformidade, stub_model(NaoConformidade,
      :item_verificacao_id => 1,
      :usuario_id => 1,
      :usuario_delegado_id => 1,
      :cliente_id => 1,
      :status => 1,
      :comentarios => "MyText"
    ))
  end

  it "renders the edit nao_conformidade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", nao_conformidade_path(@nao_conformidade), "post" do
      assert_select "input#nao_conformidade_item_verificacao_id[name=?]", "nao_conformidade[item_verificacao_id]"
      assert_select "input#nao_conformidade_usuario_id[name=?]", "nao_conformidade[usuario_id]"
      assert_select "input#nao_conformidade_usuario_delegado_id[name=?]", "nao_conformidade[usuario_delegado_id]"
      assert_select "input#nao_conformidade_cliente_id[name=?]", "nao_conformidade[cliente_id]"
      assert_select "input#nao_conformidade_status[name=?]", "nao_conformidade[status]"
      assert_select "textarea#nao_conformidade_comentarios[name=?]", "nao_conformidade[comentarios]"
    end
  end
end
