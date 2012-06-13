require 'open3'

module EasyBackup
  module Adapter
    module Db
      class PostgreSQL
        def host(host=nil)
          host ? @host = host : (@host || 'localhost')
        end

        def database(database=nil)
          database ? @database = database : @database
        end

        def username(username=nil)
          username ? @username = username : (@username || 'postgres')
        end

        def password(password=nil)
          password ? @password = password : @password
        end

        def port(port=nil)
          port ? @port = port : (@port || 5432)
        end

        def send_to(storages)
          dump_file = "#{ENV['tmp']}/easy_backup/pg_dump/#{database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
          FileUtils.mkpath File.dirname(dump_file) unless Dir.exist? File.dirname(dump_file)

          Open3.popen3 "pg_dump -h #{host} -p #{port} -U #{username} #{database} > #{dump_file}" do |i, o, e, t|
            if t.value.success?
              #TODO: Zip dump_file
              storages.each { |s| s.save dump_file }
            else
              EasyBackup.logger.error e.readlines.join
            end
          end

          FileUtils.rm dump_file if File.exist? dump_file
        end
      end
    end
  end
end

