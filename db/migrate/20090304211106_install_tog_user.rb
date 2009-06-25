class InstallTogUser < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_user", 1
  end

  def self.down
    migrate_plugin "tog_user", 0
  end
end
    