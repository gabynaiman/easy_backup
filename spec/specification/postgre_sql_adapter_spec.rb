require 'spec_helper'
require 'easy_backup'

include EasyBackup::Adapter::Db

describe PostgreSQL, '-> Specification' do

  it 'Specify database parameters' do
    db = PostgreSQL.new
    db.host '192.168.0.1'
    db.port 1234
    db.database 'test_db'
    db.username 'user'
    db.password 'password'

    db.host.should eq '192.168.0.1'
    db.port.should eq 1234
    db.database.should eq 'test_db'
    db.username.should eq 'user'
    db.password.should eq 'password'
  end

  it 'Get database default parameters' do
    db = PostgreSQL.new

    db.host.should eq 'localhost'
    db.port.should eq 5432
    db.username.should eq 'postgres'
  end

end