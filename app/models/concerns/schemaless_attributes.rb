module SchemalessAttributes
  extend ActiveSupport::Concern

  included { include Virtus }

  def method_missing(method, *args)
    nil
  end
end
