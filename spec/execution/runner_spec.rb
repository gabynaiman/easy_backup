require 'spec_helper'
require 'easy_backup'
require 'JSON'
require 'yaml'
require 'sequel'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db
include EasyBackup::Adapter::Frequency

DATA_PATH = "#{File.dirname(__FILE__)}/files/data"
BACKUP_PATH = "#{File.dirname(__FILE__)}/files/backup"

describe 'Execution' do

  context Runner do

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

    pending 'Backup PostgreSQL to file system' do
      PostgreSQLHelper.create_db
      db = PostgreSQLHelper.configuration

      config = Configuration.new do
        save PostgreSQL do
          host db['host']
          database db['database']
          username db['username']
          password db['password']
        end
        into FileSystem do
          folder "#{BACKUP_PATH}/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
        end
      end

      Runner.run config

      #TODO: Check backup results

      PostgreSQLHelper.drop_db
      FileUtils.rm_rf config.storages.first.folders.first
    end

  end

end