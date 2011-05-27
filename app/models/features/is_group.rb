module Features::IsGroup
  def self.included(model)
    model.class_eval do
      has_many :user_groups, :as => :group
      has_many :users, :through => :user_groups
    end
  end

  def attach_user(user, role_identifier = :follower)
    user_groups.create(
      :user_id         => user.id,
      :role_identifier => role_identifier
    )
  end

  def detach_user(user)
    users.delete(user)
  end
end
