class CreateTrackbacks < ActiveRecord::Migration
  def self.up
    create_table :trackbacks do |t|
      t.column :page_id,    :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :integer
      t.column :approved,   :boolean
      t.column :title,	    :string
      t.column :url,	    :string,  :null => false
      t.column :blog_name,  :string
      t.column :excerpt,    :text
    end
  end

  def self.down
    drop_table :trackbacks
  end
end
