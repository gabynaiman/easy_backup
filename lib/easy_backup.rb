require 'logger'
require 'zip/zip'
require 'net/sftp'
require 'open3'
require 'rufus-scheduler'
require 'chronic'

require 'easy_backup/resources/file_system'
require 'easy_backup/resources/sftp'
require 'easy_backup/resources/postgres'

require 'easy_backup/configuration'
require 'easy_backup/specification'

require 'easy_backup/extension/net_sftp_session'

include EasyBackup::Resources

module EasyBackup

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def scheduler
    @@scheduler ||= Rufus::Scheduler.start_new
  end

end