module AngelNest
  module TestHelpers
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def test_authentication(*actions)
        actions.each do |action|
          instance_eval do
            it "redirects to the login page from #{action}" do
              get action.to_sym
              response.should redirect_to(new_user_session_url)
            end
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include AngelNest::TestHelpers, :type => :controller
end