class CreateStartupPhotos < ActiveRecord::Migration
  def change
    create_table :startup_photos do |t|
      t.string  :photo
      t.integer :startup_id
      t.timestamps
    end

    add_index :startup_photos, :startup_id
  end
end
