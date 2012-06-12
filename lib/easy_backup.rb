require 'easy_backup/version'
require 'easy_backup/configuration'

require 'easy_backup/adapter/file_system'

require 'easy_backup/adapter/db/postgre_sql'

require 'easy_backup/adapter/frequency/day'

module EasyBackup
  def self.configurations
    @@configurations ||= {}
  end

  def self.config(name, &block)
    configurations[name] = Configuration.new
    configurations[name].instance_eval &block if block_given?
  end

end