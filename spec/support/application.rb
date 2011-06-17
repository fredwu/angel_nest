module AngelNest
  module TestHelpers
    def self.included(klass)
      klass.extend ClassMethods
    end

    def load_file(file)
      File.open("#{Rails.root}/spec/fixtures/#{file}")
    end

    module ClassMethods
      def hides_sidebar(request_type = :get, actions = [])
        generic_check('hides the sidebar', request_type, actions) do
          assigns(:hide_sidebar).should == true
        end
      end

      def authenticates_gets(*actions)
        authenticates(:get, (actions + [:index, :show, :new, :edit]))
      end

      def authenticates_posts(*actions)
        authenticates(:post, (actions + [:create, :update, :destroy]))
      end

      private

      def authenticates(request_type = :get, actions = [])
        generic_check('redirects to the login page', request_type, actions) do
          response.should redirect_to(new_user_session_url)
        end
      end

      def generic_check(test_description, request_type = :get, actions = [], &block)
        [actions].flatten.each do |action|
          it "#{test_description} from #{action}" do
            begin
              send request_type, action.to_sym, { :id => 1 }
            rescue
              send request_type, action.to_sym, { :id => 1, :user_id => 1 }
            end

            instance_eval(&block)
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include AngelNest::TestHelpers
end