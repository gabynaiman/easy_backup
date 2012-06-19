require 'spec_helper'

describe EasyBackup, '-> Specification' do

  it 'Configure a backup' do
    backup = EasyBackup::Base.new

    backup[:test_backup].should be_nil

    backup.config :test_backup do
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

    backup[:test_backup].should be_a Configuration
  end

  it 'Configure from file' do
    backup = EasyBackup::Base.new

    backup.load "#{File.dirname(__FILE__)}/../files/config/backup_config.rb"

    backup[:test_backup].should be_a Configuration
  end

  it 'Configure on new' do
    backup = EasyBackup::Base.new do
      config :test_backup do
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
    end

    backup[:test_backup].should be_a Configuration
  end

end