require 'murlsh'

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

    # populate
    require './plugins/add_pre_55_enclosure_self.rb'

    Murlsh::Url.find(:all).each do |u|
      Murlsh::Plugin.hooks('add_pre') { |p| p.run u, {} }
      u.save!
    end
  end

  def self.down
    drop_table :enclosures
  end

end
