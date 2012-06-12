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
      end
    end
  end
end

