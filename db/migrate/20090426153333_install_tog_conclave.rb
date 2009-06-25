class InstallTogConclave < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_conclave", 7
  end

  def self.down
    migrate_plugin "tog_conclave", 0
  end
end

