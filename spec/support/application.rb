module AngelNest
  module TestHelpers
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def authenticates_gets(*actions)
        authenticates(:get, (actions + [:index, :show, :new, :edit]))
      end

      def authenticates_posts(*actions)
        authenticates(:post, (actions + [:create, :update, :destroy]))
      end

      private

      def authenticates(request_type = :get, actions = [])
        actions.each do |action|
          instance_eval do
            it "redirects to the login page from #{action}" do
              begin
                send request_type, action.to_sym, { :id => 1 }
              rescue
                send request_type, action.to_sym, { :id => 1, :user_id => 1 }
              end
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