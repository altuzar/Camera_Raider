require "spec_helper"

describe StoresController do
  describe "routing" do

    it "routes to #index" do
      get("/stores").should route_to("stores#index")
    end

    it "routes to #new" do
      get("/stores/new").should route_to("stores#new")
    end

    it "routes to #show" do
      get("/stores/1").should route_to("stores#show", :id => "1")
    end

    it "routes to #edit" do
      get("/stores/1/edit").should route_to("stores#edit", :id => "1")
    end

    it "routes to #create" do
      post("/stores").should route_to("stores#create")
    end

    it "routes to #update" do
      put("/stores/1").should route_to("stores#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/stores/1").should route_to("stores#destroy", :id => "1")
    end

  end
end
