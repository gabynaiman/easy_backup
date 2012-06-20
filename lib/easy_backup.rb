require 'logger'
require 'active_support/all'

require 'easy_backup/version'
require 'easy_backup/base'
require 'easy_backup/configuration'
require 'easy_backup/runner'

require 'easy_backup/adapter/file_system'
require 'easy_backup/adapter/sftp'
require 'easy_backup/adapter/db/postgre_sql'
require 'easy_backup/adapter/frequency'

require 'easy_backup/extension/net_sftp_session'


module EasyBackup

  def self.logger
    @@logger ||= Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end
end

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db