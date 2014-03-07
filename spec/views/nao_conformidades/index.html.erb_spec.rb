require 'spec_helper'

describe "nao_conformidades/index" do
  before(:each) do
    assign(:nao_conformidades, [
      stub_model(NaoConformidade,
        :item_verificacao_id => 1,
        :usuario_id => 2,
        :usuario_delegado_id => 3,
        :cliente_id => 4,
        :status => 5,
        :comentarios => "MyText"
      ),
      stub_model(NaoConformidade,
        :item_verificacao_id => 1,
        :usuario_id => 2,
        :usuario_delegado_id => 3,
        :cliente_id => 4,
        :status => 5,
        :comentarios => "MyText"
      )
    ])
  end

  it "renders a list of nao_conformidades" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
