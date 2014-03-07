require 'spec_helper'

describe "nao_conformidades/show" do
  before(:each) do
    @nao_conformidade = assign(:nao_conformidade, stub_model(NaoConformidade,
      :item_verificacao_id => 1,
      :usuario_id => 2,
      :usuario_delegado_id => 3,
      :cliente_id => 4,
      :status => 5,
      :comentarios => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/MyText/)
  end
end
