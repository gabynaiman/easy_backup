require 'spec_helper'
require 'easy_backup'

include EasyBackup::Adapter::Db

describe PostgreSQL do

  it 'Specify database parameters' do
    db = PostgreSQL.new
    db.host 'localhost'
    db.database 'test_db'
    db.username 'user'
    db.password 'password'

    db.host.should eq 'localhost'
    db.database.should eq 'test_db'
    db.username.should eq 'user'
    db.password.should eq 'password'
  end

end