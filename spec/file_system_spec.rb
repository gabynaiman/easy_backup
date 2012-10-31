require 'spec_helper'

describe FileSystem do

  context 'Specification' do

    it 'Append folders' do
      fs = FileSystem.new do
        folder 'c:/folder1'
        folder 'c:/folder2'
      end

      fs.folders.should have(2).items
      fs.folders.should include('c:/folder1')
      fs.folders.should include('c:/folder2')
    end

    it 'Append files' do
      fs = FileSystem.new do
        file 'c:/file1.txt'
        file 'c:/file2.txt'
      end

      fs.files.should have(2).items
      fs.files.should include('c:/file1.txt')
      fs.files.should include('c:/file2.txt')
    end

    it 'Zip empty' do
      fs = FileSystem.new
      fs.zip_file.should be_nil
    end

    it 'Zip from string' do
      fs = FileSystem.new { zip 'data.zip' }
      fs.zip_file.should eq "#{EasyBackup.configuration.tmp_path}/zip/data.zip"
    end

    it 'Zip from lambda' do
      fs = FileSystem.new { zip lambda { "#{Time.now}.zip" } }
      fs.zip_file.should eq "#{EasyBackup.configuration.tmp_path}/zip/#{Time.now}.zip"
    end

  end

  context 'Save' do

    it 'File into specified folder' do
      source_file = "#{DATA_PATH}/sample.json"
      target_folder = file_helper.create_temp_folder

      fs = FileSystem.new do
        folder target_folder
      end

      File.exists?("#{target_folder}/sample.json").should be_false

      fs.save source_file

      File.exists?("#{target_folder}/#{File.basename(source_file)}").should be_true
      data = File.open(source_file, 'r') { |f| JSON.parse f.readlines.join }
      data['id'].should eq 1234
      data['name'].should eq 'sample'
    end

    it 'Folder into specified folder' do
      source_folder = "#{DATA_PATH}/txt"
      target_folder = file_helper.create_temp_folder

      fs = FileSystem.new do
        folder target_folder
      end

      fs.save source_folder

      1.upto(2) do |i|
        file = "#{source_folder}/#{i}/text#{i}.txt"
        File.exist?(file).should be_true
        File.open(file, 'r') { |f| f.gets.should eq "Text file #{i}" }
      end
    end

  end

  context 'Send' do

    it 'File to storage' do
      sample_file = "#{DATA_PATH}/sample.json"

      fs = FileSystem.new do
        file sample_file
      end

      storage = FakeStorage.new

      fs.send_to storage

      storage.received.should eq [sample_file]
    end

    it 'File and folder to storage' do
      sample_file = "#{DATA_PATH}/sample.json"
      sample_folder = "#{DATA_PATH}/txt"

      fs = FileSystem.new do
        file sample_file
        folder sample_folder
      end

      storage = FakeStorage.new

      fs.send_to storage

      storage.received.should eq [sample_file, sample_folder]
    end

    it 'Zipped file to storage' do
      sample_file = "#{DATA_PATH}/sample.json"
      sample_folder = "#{DATA_PATH}/txt"

      fs = FileSystem.new do
        file sample_file
        folder sample_folder
        zip 'sample.zip'
      end

      storage = FakeStorage.new

      fs.send_to storage

      storage.received.should eq [fs.zip_file]
    end

  end

end