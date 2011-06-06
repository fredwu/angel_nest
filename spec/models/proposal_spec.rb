require 'spec_helper'

describe Proposal do
  it "converts content to json_content" do
    proposal = Proposal.new
    proposal.content = { 'hello' => 'world' }

    proposal.json_content.should == '{"hello":"world"}'
  end
end
