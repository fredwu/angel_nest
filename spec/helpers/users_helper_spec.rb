require 'spec_helper'

describe UsersHelper do
  describe "#find_geo_location" do
    it "gets the geo location of the current user" do
      helper.find_geo_location.should == {
        :city         => '(Private Address)',
        :region       => nil,
        :country_code => 'XX',
        :country      => nil,
        :ip           => '0.0.0.0',
        :timezone     => nil,
      }
    end

    it "gets the geo location for a given IP address" do
      helper.find_geo_location('8.8.8.8').should == {
        :city         => 'Mountain View',
        :region       => 'CA',
        :country_code => 'US',
        :country      => 'United States',
        :longitude    => '-122.078',
        :latitude     => '37.402',
        :ip           => '8.8.8.8',
        :timezone     => 'America/Los_Angeles',
      }
    end
  end
end
