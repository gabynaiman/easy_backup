require 'spec_helper'
require 'easy_backup'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db
include EasyBackup::Adapter::Frequency

describe 'Specification' do

  context Configuration do

    it 'Save file system' do
      config = Configuration.new

      config.resources.should be_empty

      config.save FileSystem do
        folder 'c:/folder1'
        file 'c:/folder2/file.txt'
      end

      config.save FileSystem do
        folder 'c:/folder3'
        folder 'c:/folder4'
        folder 'c:/folder5'
      end

      config.resources.should have(2).items

      config.resources[0].should be_a FileSystem
      config.resources[0].folders.should have(1).items
      config.resources[0].folders.should include 'c:/folder1'
      config.resources[0].files.should have(1).items
      config.resources[0].files.should include 'c:/folder2/file.txt'

      config.resources[1].should be_a FileSystem
      config.resources[1].folders.should have(3).items
      config.resources[1].folders.should include 'c:/folder3'
      config.resources[1].folders.should include 'c:/folder4'
      config.resources[1].folders.should include 'c:/folder5'
    end

    it 'Save postgre sql' do
      config = Configuration.new

      config.resources.should be_empty

      config.save PostgreSQL do
        host '192.168.0.0'
        database 'db0'
        username 'user0'
        password 'password0'
      end

      config.save PostgreSQL do
        host '192.168.0.1'
        database 'db1'
        username 'user1'
        password 'password1'
      end

      config.resources.should have(2).items

      (0..1).each do |i|
        config.resources[i].should be_a PostgreSQL
        config.resources[i].host.should eq "192.168.0.#{i}"
        config.resources[i].database.should eq "db#{i}"
        config.resources[i].username.should eq "user#{i}"
        config.resources[i].password.should eq "password#{i}"
      end

    end

    it 'In file system' do
      config = Configuration.new

      config.storages.should be_empty

      config.into FileSystem do
        folder 'c:/backup'
      end

      config.into FileSystem do
        folder 'c:/other_backup'
      end

      config.storages.should have(2).items
      config.storages[0].folders[0].should eq 'c:/backup'
      config.storages[1].folders[0].should eq 'c:/other_backup'
    end

    it 'Execute every day at specific hour' do
      config = Configuration.new

      config.frequencies.should be_empty

      config.every Day do
        at '10'
      end

      config.every Day do
        at '22:45:01'
      end

      config.frequencies.should have(2).items

      config.frequencies[0].should be_a Day
      config.frequencies[0].hour.should be 10
      config.frequencies[0].minute.should be 0
      config.frequencies[0].second.should be 0

      config.frequencies[1].should be_a Day
      config.frequencies[1].hour.should be 22
      config.frequencies[1].minute.should be 45
      config.frequencies[1].second.should be 1
    end

  end

end