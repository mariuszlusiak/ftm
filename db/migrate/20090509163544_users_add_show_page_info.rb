class UsersAddShowPageInfo < ActiveRecord::Migration
  def self.up
		add_column :users, :show_page_info, :boolean, :null => false, :default => true
  end

  def self.down
		remove_column :users, :show_page_info
  end
end
