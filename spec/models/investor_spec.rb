require 'spec_helper'

describe Investor do
  it_behaves_like "paramable"

  it "has #for_auto_suggest" do
    investor = Investor.make!
    [investor].for_auto_suggest.should be_a(Array)
    [investor].for_auto_suggest.should == [{ :id => investor.id, :name => investor.name }]
  end
end
