require 'spec_helper'
require 'easy_backup'

include EasyBackup::Adapter

describe FileSystem do

  it 'Append folders' do
    fs = FileSystem.new
    fs.folder 'c:/folder1'
    fs.folder 'c:/folder2'

    fs.folders.should have(2).items
    fs.folders.should include('c:/folder1')
    fs.folders.should include('c:/folder2')
  end

end