require "spec_helper"

describe NaoConformidadesController do
  describe "routing" do

    it "routes to #index" do
      get("/nao_conformidades").should route_to("nao_conformidades#index")
    end

    it "routes to #new" do
      get("/nao_conformidades/new").should route_to("nao_conformidades#new")
    end

    it "routes to #show" do
      get("/nao_conformidades/1").should route_to("nao_conformidades#show", :id => "1")
    end

    it "routes to #edit" do
      get("/nao_conformidades/1/edit").should route_to("nao_conformidades#edit", :id => "1")
    end

    it "routes to #create" do
      post("/nao_conformidades").should route_to("nao_conformidades#create")
    end

    it "routes to #update" do
      put("/nao_conformidades/1").should route_to("nao_conformidades#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/nao_conformidades/1").should route_to("nao_conformidades#destroy", :id => "1")
    end

  end
end
