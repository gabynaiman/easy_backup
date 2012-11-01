require 'easy_backup'
require 'sequel'
require 'json'

include EasyBackup

DATA_PATH = "#{File.dirname(__FILE__)}/files/data"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include FileHelper::Rspec

  config.before :each do
    initialize_file_helper
  end

  config.after :each do
    file_helper.remove_temp_folders
  end

  config.after :all do
    FileUtils.rm_rf EasyBackup.configuration.tmp_path
  end
end