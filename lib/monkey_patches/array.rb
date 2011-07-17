class Array
  def for_auto_suggest
    map { |r| { :id => r.id, :name => r.name } }
  end
end
