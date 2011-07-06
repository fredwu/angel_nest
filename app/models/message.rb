class Message < ActiveRecord::Base
  belongs_to :user, :counter_cache => :messages_count
  belongs_to :target, :polymorphic => true, :counter_cache => :comments_count

  validates :content, :presence => true,
                      :length   => { :maximum => 140 }

  scope :default_order, order('created_at DESC')
  scope :public,        where(:is_private => false)
  scope :private,       where(:is_private => true)
  scope :read,          where(:is_read => true)
  scope :unread,        where(:is_read => false)
  scope :micro_posts,   where(:target_id => nil)
  scope :on_users,      where(:target_type => 'User')
  scope :on_startups,   where(:target_type => 'Startup')

  def is_public?
    !is_private
  end

  def is_private?
    !!is_private
  end

  def is_read?
    !!is_read
  end

  def is_unread?
    !is_read
  end

  def mark_as_read!
    update_attribute :is_read, true
  end

  def mark_as_unread!
    update_attribute :is_read, false
  end
end
