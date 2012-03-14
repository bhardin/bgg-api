require "rspec"


describe "BGG Search" do

  it "some results come back" do
    bgg = BggApi.new
    results = bgg.search({:query => "Burgund", :type => 'boardgame'})

    results.should_not be_nil
  end
end