module UsersHelper
  def find_geo_location(remote_ip = nil)
    GeoLocation.find(remote_ip || request.remote_ip)
  end
end
