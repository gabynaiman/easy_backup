# EasyBackup

[![Gem Version](https://badge.fury.io/rb/easy_backup.png)](https://rubygems.org/gems/easy_backup)

Simple DSL to program backups

## Installation

Add this line to your application's Gemfile:

    gem 'easy_backup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_backup

## Usage

    EasyBackup::Specification.new do

      save Postgres do
        host     'localhost'
        port     5432
        database 'db_production'
        username 'user_prod'
        password 'password'
        zip
      end

      save FileSystem do
        folder 'c:/resources'
        file   'c:/data/file.txt'
        zip    'data.zip'
      end

      into FileSystem do
        folder lambda { "c:/backups/#{Time.now.strftime('%Y%m%d%H%M%S')}" }
      end

      into SFTP do
        host     'remote'
        username 'user_sftp'
        password 'password'
        folder   "backups/#{Time.now.strftime('%Y%m%d%H%M%S')}"
      end

      schedule :every, '3h', :first_at => Chronic.parse('this tuesday 5:00')

    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
