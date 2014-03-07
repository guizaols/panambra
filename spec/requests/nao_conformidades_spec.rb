require 'spec_helper'

describe "NaoConformidades" do
  describe "GET /nao_conformidades" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get nao_conformidades_path
      response.status.should be(200)
    end
  end
end
