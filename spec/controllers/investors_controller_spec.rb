require 'spec_helper'

describe InvestorsController do
  it_behaves_like "ensure_ownership"
  include_context "inherited_resources"
end
