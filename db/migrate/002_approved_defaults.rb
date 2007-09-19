class ApprovedDefaults < ActiveRecord::Migration
  def self.up
    change_column :trackbacks, :approved, :boolean, :default => false
  end

  def self.down
    change_column :trackbacks, :approved, :boolean, :default => nil
  end
end
