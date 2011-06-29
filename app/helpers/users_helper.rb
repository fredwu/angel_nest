module UsersHelper
  def find_geo_location
    GeoLocation.find(request.remote_ip)
  end

  def detected_country;         find_geo_location[:country]                     end
  def detected_country_code;    find_geo_location[:country_code]                end
  def detected_city;            find_geo_location[:city]                        end
  def detected_region;          find_geo_location[:region]                      end
  def detected_timezone;        find_geo_location[:timezone]                    end
  def detected_city_and_region; [detected_city, detected_region].compact * ', ' end

  def show_user_roles(user)
    roles = []
    roles << t('label.entrepreneur') if user.is_entrepreneur?
    roles << t('label.investor') if user.is_investor?

    if roles.any?
      " (#{roles * ', '})".html_safe
    else
      ''
    end
  end
end
