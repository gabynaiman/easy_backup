require 'logger'
require 'active_support/all'

require 'easy_backup/version'
require 'easy_backup/configuration'
require 'easy_backup/runner'

require 'easy_backup/adapter/file_system'
require 'easy_backup/adapter/sftp'
require 'easy_backup/adapter/db/postgre_sql'

require 'easy_backup/extension/net_sftp_session'

require 'easy_backup/schedule/timer'
require 'easy_backup/schedule/cron'
require 'easy_backup/schedule/scheduler'

module EasyBackup
  include EasyBackup::Adapter
  include EasyBackup::Adapter::Db

  def self.load(config_file)
    eval File.open(config_file, 'r') { |f| f.readlines.join("\n") }
  end

  def self.backup(name, &block)
    configurations[name] = Configuration.new
    configurations[name].instance_eval &block if block_given?
  end

  def self.configurations
    @@configurations ||= {}
  end

  def self.[](name)
    configurations[name]
  end

  def self.logger
    @@logger ||= Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end

end