class CreateEnclosures < ActiveRecord::Migration

  def self.up
    create_table :enclosures do |t|
      t.integer :content_length
      t.string  :content_type
      t.string  :title
      t.string  :enclosure_url

      t.references :url
    end

    add_index :enclosures, :url_id
  end

  def self.down
    drop_table :enclosures
  end

end
