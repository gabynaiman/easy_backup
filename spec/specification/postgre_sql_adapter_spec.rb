require 'spec_helper'

describe PostgreSQL, '-> Specification' do

  it 'Specify database parameters' do
    db = PostgreSQL.new
    db.host '192.168.0.1'
    db.port 1234
    db.database 'test_db'
    db.username 'user'
    db.password 'password'
    db.dump_file 'db.sql'
    db.zip

    db.host.should eq '192.168.0.1'
    db.port.should eq 1234
    db.database.should eq 'test_db'
    db.username.should eq 'user'
    db.password.should eq 'password'
    db.dump_file.should eq 'db.sql'
    db.zip_file.should eq 'db.zip'
  end

  it 'Get database default parameters' do
    db = PostgreSQL.new

    db.host.should eq 'localhost'
    db.port.should eq 5432
    db.database.should be_nil
    db.username.should eq 'postgres'
    db.password.should be_nil
    db.dump_file.should eq "#{db.database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
    db.zip_file.should be_nil
  end

end