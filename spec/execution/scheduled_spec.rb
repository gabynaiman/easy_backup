require 'spec_helper'

DATA_PATH = "#{File.dirname(__FILE__)}/../files/data"
BACKUP_PATH = "#{ENV['tmp'].gsub('\\', '/')}/easy_backup/test/backups"

describe EasyBackup, '-> Scheduled run' do

  it 'Run scheduled backup' do
    test_path = "#{BACKUP_PATH}/#{Time.now.to_f}"

    EasyBackup::Base.new 0.5 do
      config :test_backup do
        save FileSystem do
          file "#{DATA_PATH}/txt/1/text1.txt"
        end
        into FileSystem do
          folder lambda { "#{test_path}/#{Time.now.strftime('%Y-%m-%d %H_%M_%S_%L')}" }
        end
        every 0.5, from: 1.second.from_now
      end
    end

    sleep(2)

    Dir.glob("#{test_path}/*").should have(2).items

    FileUtils.rm_rf test_path
  end

end