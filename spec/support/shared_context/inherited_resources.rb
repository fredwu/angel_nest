shared_context "inherited_resources" do
  let(:resource)   { @controller.send(:resource) }
  let(:collection) { @controller.send(:collection) }
end