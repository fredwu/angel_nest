module AngelNest
  module AutoUserScoping
    def self.included(controller)
      controller.instance_eval do
        belongs_to :user, :optional => true
      end
    end

    def my_index
      params[:user_id] = current_user.id
      index
    end
  end
end