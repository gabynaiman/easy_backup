require 'spec_helper'

DATA_PATH = "#{File.dirname(__FILE__)}/../files/data"
BACKUP_PATH = "#{ENV['tmp'].gsub('\\', '/')}/easy_backup/test/backups"

describe EasyBackup, '-> Scheduled run' do

  it 'Run scheduled backup' do
    test_path = "#{BACKUP_PATH}/#{Time.now.to_f}"
    puts test_path
    backup = EasyBackup::Base.new 0.1 do
      config :test_backup do
        save FileSystem do
          file "#{DATA_PATH}/txt/1/text1.txt"
        end
        into FileSystem do
          folder lambda { "#{test_path}/#{Time.now.strftime('%Y-%m-%d %H_%M_%S_%L')}" }
        end
        every 0.5
      end
    end

    backup.start
    sleep(2.1)
    backup.stop

    Dir.glob("#{test_path}/*").should have(4).items

    FileUtils.rm_rf test_path
  end

end