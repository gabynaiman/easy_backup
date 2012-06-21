require 'rubygems'
require 'bundler/setup'
require 'easy_backup'

DATA_PATH = "#{File.dirname(__FILE__)}/files/data"
BACKUP_PATH = "#{ENV['tmp'].gsub('\\', '/')}/easy_backup/backups"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end