require "spec_helper"

describe SpecialDatesController do
  describe "routing" do

    it "routes to #index" do
      get("/special_dates").should route_to("special_dates#index")
    end

    it "routes to #new" do
      get("/special_dates/new").should route_to("special_dates#new")
    end

    it "routes to #show" do
      get("/special_dates/1").should route_to("special_dates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/special_dates/1/edit").should route_to("special_dates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/special_dates").should route_to("special_dates#create")
    end

    it "routes to #update" do
      put("/special_dates/1").should route_to("special_dates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/special_dates/1").should route_to("special_dates#destroy", :id => "1")
    end

  end
end
