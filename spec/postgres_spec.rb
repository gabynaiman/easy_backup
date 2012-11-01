require 'spec_helper'

describe Postgres do

  context 'Specification' do

    it 'Database parameters' do
      db = Postgres.new
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
      db.dump_file.should eq "#{EasyBackup.configuration.tmp_path}/pg_dump/db.sql"
      db.zip_file.should eq "#{EasyBackup.configuration.tmp_path}/pg_dump/db.zip"
    end

    it 'Database default parameters' do
      db = Postgres.new

      db.host.should eq 'localhost'
      db.port.should eq 5432
      db.database.should be_nil
      db.username.should eq 'postgres'
      db.password.should be_nil
      db.dump_file.should eq "#{EasyBackup.configuration.tmp_path}/pg_dump/_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
      db.zip_file.should be_nil
    end

  end

  context 'Send' do

    before :all do
      PostgresHelper.create_db
    end

    after :all do
      PostgresHelper.drop_db
    end

    it 'Dump to sql file' do
      db = PostgresHelper.configuration

      pg = Postgres.new do
        host db['host']
        database db['database']
        port db['port']
        username db['username']
        password db['password']
        dump_file 'backup.sql'
      end

      storage = FakeStorage.new

      pg.send_to storage

      storage.received.should eq ["#{EasyBackup.configuration.tmp_path}/pg_dump/backup.sql"]
    end

    it 'Dump with lambda expression' do
      db = PostgresHelper.configuration

      pg = Postgres.new do
        host db['host']
        database db['database']
        port db['port']
        username db['username']
        password db['password']
      end

      storage = FakeStorage.new

      pg.send_to storage

      sleep 1

      storage.received.should eq [pg.dump_file]
    end

    it 'Zip after dump' do
      db = PostgresHelper.configuration

      pg = Postgres.new do
        host db['host']
        database db['database']
        port db['port']
        username db['username']
        password db['password']
        dump_file 'backup.sql'
        zip
      end

      storage = FakeStorage.new

      pg.send_to storage

      storage.received.should eq ["#{EasyBackup.configuration.tmp_path}/pg_dump/backup.zip"]
    end

    it 'Zip with lambda expression' do
      db = PostgresHelper.configuration

      pg = Postgres.new do
        host db['host']
        database db['database']
        port db['port']
        username db['username']
        password db['password']
        zip
      end

      storage = FakeStorage.new

      pg.send_to storage

      sleep 1

      storage.received.should eq [pg.zip_file]
    end

  end

end