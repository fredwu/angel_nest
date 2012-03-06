module Commentable
  extend ActiveSupport::Concern

  included do
    attr_readonly :comments_count

    has_many :comments, :class_name => 'Message', :as => :target, :order => 'created_at DESC'
  end

  def add_comment(user, content, options = {})
    options = { :is_private => false }.merge(options)

    Message.create({
      :content     => content,
      :is_private  => options[:is_private],
      :target_id   => id,
      :target_type => self.class.name,
      :user_id     => user.id
    }, :as => :internal) && reload
  end

  def add_private_comment(user, content, options = {})
    options.merge!({ :is_private => true })

    add_comment(user, content, options)
  end
end
