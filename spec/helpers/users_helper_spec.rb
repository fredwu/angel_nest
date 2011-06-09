require 'spec_helper'

describe UsersHelper do
  context "geo location detectors" do
    let(:geo_location_hash) do
      {
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

    before do
      GeoLocation.stub(:find).and_return(geo_location_hash)
    end

    it "returns correct geo location hash from the remote server" do
      helper.find_geo_location.should == geo_location_hash
    end

    it "detects the country of the current user" do
      helper.detected_country.should == 'United States'
    end

    it "detects the country code of the current user" do
      helper.detected_country_code.should == 'US'
    end

    context "city and region" do
      context "city with region" do
        it "detects the city and region of the current user" do
          helper.detected_city_and_region.should == 'Mountain View, CA'
        end
      end

      context "city with no region" do
        before { geo_location_hash[:region] = nil }

        it "detects the city and region of the current user" do
          helper.detected_city_and_region.should == 'Mountain View'
        end
      end

      context "region with no city" do
        before { geo_location_hash[:city] = nil }

        it "detects the city and region of the current user" do
          helper.detected_city_and_region.should == 'CA'
        end
      end

      context "no city and no region" do
        before do
          geo_location_hash[:city]   = nil
          geo_location_hash[:region] = nil
        end

        it "detects the city and region of the current user" do
          helper.detected_city_and_region.should == ''
        end
      end
    end

    it "detects the timezone of the current user" do
      helper.detected_timezone.should == 'America/Los_Angeles'
    end
  end
end
