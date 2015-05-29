require "spec_helper"

describe HorariosController do
  describe "routing" do

    it "routes to #index" do
      get("/horarios").should route_to("horarios#index")
    end

    it "routes to #new" do
      get("/horarios/new").should route_to("horarios#new")
    end

    it "routes to #show" do
      get("/horarios/1").should route_to("horarios#show", :id => "1")
    end

    it "routes to #edit" do
      get("/horarios/1/edit").should route_to("horarios#edit", :id => "1")
    end

    it "routes to #create" do
      post("/horarios").should route_to("horarios#create")
    end

    it "routes to #update" do
      put("/horarios/1").should route_to("horarios#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/horarios/1").should route_to("horarios#destroy", :id => "1")
    end

  end
end
