require 'spec_helper'

describe StartupPhoto do
  let(:startup) { Startup.make! }

  describe "photo" do
    let(:uploader) { StartupPhotoUploader.new(StartupPhoto.new, :photo) }

    it "does not save invalid file types" do
      expect { uploader.store!(load_file('file.gif')) }.to raise_exception(CarrierWave::IntegrityError)
    end

    it "reads the saved logo" do
      uploader.store!(load_file('file.jpg'))
      uploader.to_s.should match(/photo\.jpg/)
      uploader.gallery.to_s.should match(/photo\.jpg/)
    end
  end
end
