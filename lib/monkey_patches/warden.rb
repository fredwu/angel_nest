module Warden::Mixins::Common
  # overwrites session reset so that we could keep things like 'last_visited_page'
  def reset_session!
    nil
  end
end