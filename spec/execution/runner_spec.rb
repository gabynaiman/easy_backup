require 'spec_helper'
require 'easy_backup'
require 'JSON'
require 'yaml'
require 'sequel'
require 'zip/zip'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db
include EasyBackup::Adapter::Frequency

DATA_PATH = "#{File.dirname(__FILE__)}/files/data"
BACKUP_PATH = "#{ENV['tmp'].gsub('\\', '/')}/easy_backup/test/backups"

describe Runner, '-> Execution' do

  it 'Backup a file to file system' do
    config = Configuration.new do
      save FileSystem do
        file "#{DATA_PATH}/sample.json"
      end
      into FileSystem do
        folder "#{BACKUP_PATH}/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
      end
    end

    Runner.run config

    file = "#{config.storages.first.folders.first}/sample.json"
    File.exist?(file).should be_true
    data = File.open(file, 'r') { |f| JSON.parse f.readlines.join }
    data['id'].should be 1234
    data['name'].should eq 'sample'

    FileUtils.rm_rf config.storages.first.folders.first
  end

  it 'Backup folder to file system' do
    config = Configuration.new do
      save FileSystem do
        folder "#{DATA_PATH}/txt"
      end
      into FileSystem do
        folder "#{BACKUP_PATH}/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
      end
    end

    Runner.run config

    path = "#{config.storages.first.folders.first}/txt"
    (1..2).each do |i|
      file = "#{path}/#{i}/text#{i}.txt"
      File.exist?(file).should be_true
      File.open(file, 'r') { |f| f.gets.should eq "Text file #{i}" }
    end

    FileUtils.rm_rf config.storages.first.folders.first
  end

  it 'Backup PostgreSQL to file system' do
    PostgreSQLHelper.create_db
    db = PostgreSQLHelper.configuration
    backup_path = "#{BACKUP_PATH}/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"

    config = Configuration.new do
      save PostgreSQL do
        host db['host']
        database db['database']
        port db['port']
        username db['username']
        password db['password']
      end
      into FileSystem do
        folder backup_path
      end
    end

    Runner.run config

    Dir["#{backup_path}/#{db['database']}_*.zip"].should have(1).items
    Zip::ZipFile.foreach(Dir["#{backup_path}/#{db['database']}_*.zip"].first) do |entry|
      entry.get_input_stream.read.should include 'PostgreSQL database dump'
    end

    PostgreSQLHelper.drop_db
    FileUtils.rm_rf backup_path
  end

end