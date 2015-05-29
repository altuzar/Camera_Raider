require 'spec_helper'

describe "Traficos" do
  describe "GET /traficos" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get traficos_path
      response.status.should be(200)
    end
  end
end
