module Paramable
  extend ActiveSupport::Concern

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
