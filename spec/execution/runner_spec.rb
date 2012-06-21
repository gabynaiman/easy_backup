require 'spec_helper'
require 'JSON'
require 'yaml'
require 'sequel'
require 'zip/zip'
require 'net/sftp'

describe Runner, '-> Execution' do

  after :all do
    FileUtils.rm_rf BACKUP_PATH
  end

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
  end

  it 'Backup file and folder zipped to file system' do
    zip_file = "data_#{Time.now.strftime('%Y%m%d%H%M%S%L')}.zip"
    backup_path = "#{BACKUP_PATH}/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"

    config = Configuration.new do
      save FileSystem do
        folder "#{DATA_PATH}/txt"
        folder "#{DATA_PATH}/sample.json"
        zip zip_file
      end
      into FileSystem do
        folder backup_path
      end
    end

    Runner.run config

    File.exists?("#{backup_path}/#{zip_file}").should be_true

    Zip::ZipFile.open("#{backup_path}/#{zip_file}") do |zip|
      zip.find_entry('sample.json').should_not be_nil
      zip.find_entry('txt/1/text1.txt').should_not be_nil
      zip.find_entry('txt/2/text2.txt').should_not be_nil
    end
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
        zip
      end
      into FileSystem do
        folder backup_path
      end
    end

    Runner.run config

    PostgreSQLHelper.drop_db

    Dir["#{backup_path}/#{db['database']}_*.zip"].should have(1).items
    Zip::ZipFile.foreach(Dir["#{backup_path}/#{db['database']}_*.zip"].first) do |entry|
      entry.get_input_stream.read.should include 'PostgreSQL database dump'
    end
  end

  it 'Backup a file to sftp' do
    storage = ConfigHelper.get 'sftp'
    backup_path = "tmp/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
    config = Configuration.new do
      save FileSystem do
        file "#{DATA_PATH}/txt/1/text1.txt"
      end
      into SFTP do
        host storage['host']
        username storage['username']
        password storage['password']
        folder backup_path
      end
    end

    Runner.run config

    Net::SFTP.start(storage['host'], storage['username'], :password => storage['password']) do |sftp|
      sftp.dir.glob(backup_path, 'text1.txt').should have(1).item
      sftp.file.open("#{backup_path}/text1.txt", 'r') { |f| f.gets.should eq 'Text file 1' }
    end
  end

end