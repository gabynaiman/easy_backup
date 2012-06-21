require 'logger'
require 'active_support/all'

require 'easy_backup/version'
require 'easy_backup/base'
require 'easy_backup/configuration'
require 'easy_backup/frequency'
require 'easy_backup/runner'

require 'easy_backup/adapter/file_system'
require 'easy_backup/adapter/sftp'
require 'easy_backup/adapter/db/postgre_sql'

require 'easy_backup/extension/net_sftp_session'


include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db

module EasyBackup

  def self.logger
    @@logger ||= Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end

  def self.interval
    @@interval ||= 1.minute
  end

  def self.interval=(interval)
    @@interval = interval
  end

  def self.config(name=:default, &block)
    Base.new do
      config name, &block
    end
  end

  def self.load(config_file)
    Base.new do
      eval File.open(config_file, 'r') { |f| f.readlines.join("\n") }
    end
  end

end