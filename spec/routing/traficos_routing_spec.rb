require "spec_helper"

describe TraficosController do
  describe "routing" do

    it "routes to #index" do
      get("/traficos").should route_to("traficos#index")
    end

    it "routes to #new" do
      get("/traficos/new").should route_to("traficos#new")
    end

    it "routes to #show" do
      get("/traficos/1").should route_to("traficos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/traficos/1/edit").should route_to("traficos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/traficos").should route_to("traficos#create")
    end

    it "routes to #update" do
      put("/traficos/1").should route_to("traficos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/traficos/1").should route_to("traficos#destroy", :id => "1")
    end

  end
end
