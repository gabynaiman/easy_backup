require 'spec_helper'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db

describe EasyBackup, '-> Specification' do

  it 'Configure a backup' do
    EasyBackup.configurations.should be_empty

    EasyBackup.backup :test_backup do
      save PostgreSQL do
        host 'localhost'
        database 'test_db'
        username 'user'
        password 'password'
      end

      save FileSystem do
        folder 'c:/data'
      end

      into FileSystem do
        folder 'c:/backup'
      end

      every 1.day, from: 'today at 22:30'
    end

    EasyBackup.configurations.should have_key :test_backup
    EasyBackup[:test_backup].should be_a Configuration
  end

  it 'Configure from file' do
    EasyBackup.load "#{File.dirname(__FILE__)}/../files/config/backup_config.rb"

    EasyBackup.configurations.should have_key :test_backup
    EasyBackup[:test_backup].should be_a Configuration
  end

end