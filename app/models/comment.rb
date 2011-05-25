class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => :micro_posts_count
  belongs_to :target, :polymorphic => true, :counter_cache => :comments_count

  scope :default_order, order('created_at DESC')
  scope :public,        where(:is_private => false)
  scope :private,       where(:is_private => true)
  scope :on_users,      where(:target_type => 'User')
  scope :on_angels,     where(:target_type => 'Angel')
  scope :on_startups,   where(:target_type => 'Startup')

  default_scope public.default_order

  def self.add(content, *options)
    options = { :is_private => false }.merge(options)

    create(:content => content, :is_private => is_private)
  end
end
