class Message < ActiveRecord::Base
  belongs_to :user, :counter_cache => :messages_count
  belongs_to :target, :polymorphic => true, :counter_cache => :comments_count

  validates :content, :presence => true,
                      :length   => { :maximum => 140 }

  scope :default_order, order('created_at DESC')
  scope :public,        where(:is_private => false)
  scope :private,       where(:is_private => true)
  scope :micro_posts,   where(:target_id => nil)
  scope :on_users,      where(:target_type => 'User')
  scope :on_startups,   where(:target_type => 'Startup')
end
