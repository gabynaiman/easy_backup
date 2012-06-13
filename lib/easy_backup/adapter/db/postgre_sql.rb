module EasyBackup
  module Adapter
    module Db
      class PostgreSQL
        def host(host=nil)
          host ? @host = host : @host
        end

        def database(database=nil)
          database ? @database = database : @database
        end

        def username(username=nil)
          username ? @username = username : @username
        end

        def password(password=nil)
          password ? @password = password : @password
        end

        def send_to(storages)
          #TODO: execute ENV['pg_home'] pg_dump -h -p -U dbname > path/tmp/dbname_timestamp.sql
          #      zip to path/tmp/dbname_timestamp.zip
          #      storages.each { |s| s.save path/tmp/dbname_timestamp.zip }
          #      FileUtils.rm path/tmp/dbname_timestamp.sql
          #      FileUtils.rm path/tmp/dbname_timestamp.zip
        end
      end
    end
  end
end

