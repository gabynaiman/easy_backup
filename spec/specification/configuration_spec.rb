require 'spec_helper'
require 'easy_backup'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db
include EasyBackup::Adapter::Frequency

describe Configuration do

  it 'Guard file system' do
    config = Configuration.new

    config.guards.should be_empty

    config.guard FileSystem do
      folder 'c:/folder1'
      folder 'c:/folder2'
    end

    config.guard FileSystem do
      folder 'c:/folder3'
      folder 'c:/folder4'
      folder 'c:/folder5'
    end

    config.guards.should have(2).items

    config.guards[0].should be_a FileSystem
    config.guards[0].folders.should have(2).items
    config.guards[0].folders.should include 'c:/folder1'
    config.guards[0].folders.should include 'c:/folder2'

    config.guards[1].should be_a FileSystem
    config.guards[1].folders.should have(3).items
    config.guards[1].folders.should include 'c:/folder3'
    config.guards[1].folders.should include 'c:/folder4'
    config.guards[1].folders.should include 'c:/folder5'
  end

  it 'Guard postgre sql' do
    config = Configuration.new

    config.guards.should be_empty

    config.guard PostgreSQL do
      host '192.168.0.0'
      database 'db0'
      username 'user0'
      password 'password0'
    end

    config.guard PostgreSQL do
      host '192.168.0.1'
      database 'db1'
      username 'user1'
      password 'password1'
    end

    config.guards.should have(2).items

    (0..1).each do |i|
      config.guards[i].should be_a PostgreSQL
      config.guards[i].host.should eq "192.168.0.#{i}"
      config.guards[i].database.should eq "db#{i}"
      config.guards[i].username.should eq "user#{i}"
      config.guards[i].password.should eq "password#{i}"
    end

  end

  it 'Store in file system' do
    config = Configuration.new

    config.storages.should be_empty

    config.store_in FileSystem do
      folder 'c:/backup'
    end

    config.store_in FileSystem do
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