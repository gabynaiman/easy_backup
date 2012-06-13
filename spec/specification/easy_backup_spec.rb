require 'spec_helper'
require 'easy_backup'

include EasyBackup
include EasyBackup::Adapter
include EasyBackup::Adapter::Db
include EasyBackup::Adapter::Frequency

describe EasyBackup, '-> Specification' do

  it 'Configure a backup' do
    EasyBackup.configurations.should be_empty

    EasyBackup.config :test_backup do
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

      every Day do
        at '22:30'
      end
    end

    EasyBackup.configurations.should have_key :test_backup
    EasyBackup[:test_backup].should be_a Configuration
  end

end