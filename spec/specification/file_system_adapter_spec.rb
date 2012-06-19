require 'spec_helper'

describe FileSystem, '-> Specification' do

  it 'Append folders' do
    fs = FileSystem.new
    fs.folder 'c:/folder1'
    fs.folder 'c:/folder2'

    fs.folders.should have(2).items
    fs.folders.should include('c:/folder1')
    fs.folders.should include('c:/folder2')
  end

  it 'Append files' do
    fs = FileSystem.new
    fs.file 'c:/file1'
    fs.file 'c:/file2'

    fs.files.should have(2).items
    fs.files.should include('c:/file1')
    fs.files.should include('c:/file2')
  end

end