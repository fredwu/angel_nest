module AutoUserScoping
  extend ActiveSupport::Concern

  included do
    belongs_to :user, :optional => true
  end

  def my_index
    params[:user_id] = current_user.id
    index
  end
end