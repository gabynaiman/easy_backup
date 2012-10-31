require 'spec_helper'

describe SFTP do

  context 'Specification' do

    it 'Sftp parameters' do
      sftp = SFTP.new do
        host '192.168.0.1'
        username 'user'
        password 'password'
        folder '/backup'
      end

      sftp.host.should eq '192.168.0.1'
      sftp.username.should eq 'user'
      sftp.password.should eq 'password'
      sftp.folder.should eq '/backup'
    end

  end

  context 'Save' do

    it 'File to sftp' do
      config = ConfigHelper.get 'sftp'
      backup_path = "tmp/#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
      source_file = "#{DATA_PATH}/txt/1/text1.txt"

      sftp = SFTP.new do
        host config['host']
        username config['username']
        password config['password']
        folder backup_path
      end

      sftp.save source_file

      Net::SFTP.start(config['host'], config['username'], password: config['password']) do |sftp|
        sftp.dir.glob(backup_path, 'text1.txt').should have(1).item
        sftp.file.open("#{backup_path}/text1.txt", 'r') { |f| f.gets.should eq 'Text file 1' }
      end
    end

  end

end