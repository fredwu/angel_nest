module AngelNest
  module AutoUserScoping
    def self.included(controller)
      if controller == UsersController
        controller.send :include, UserResource
      else
        controller.send :include, UserScopeResource
      end
    end

    module UserResource
      private

      def resource
        super
      rescue ActiveRecord::RecordNotFound
        current_user
      end
    end

    module UserScopeResource
      def my_index
        params[:user_id] = current_user.id
        index
      end

      private

      def begin_of_association_chain
        if user_id = params[:user_id]
          User.find(user_id)
        end
      end
    end
  end
end