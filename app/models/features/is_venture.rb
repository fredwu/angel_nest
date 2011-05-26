module Features::IsVenture
  def self.included(model)
    model.class_eval do
      has_many :user_ventures, :as => :venture
      has_many :users, :through => :user_ventures
    end
  end

  def add_user(user, role_identifier = :follower)
    user_ventures.create(
      :user_id      => user.id,
      :venture_role => role_identifier
    )
  end

  def remove_user(user)
    users.delete(user)
  end
end
