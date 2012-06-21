require 'open3'
require 'zip/zip'

include Zip

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
          dump_file = "#{EasyBackup.tmp_path}/pg_dump/#{database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
          zip_file = dump_file.gsub '.sql', '.zip'
          FileUtils.mkpath File.dirname(dump_file) unless Dir.exist? File.dirname(dump_file)

          EasyBackup.logger.info "[PostgreSQL] Dump postgres://#{username}:*****@#{host}:#{port}/#{database}\n#{' '*15}to #{dump_file}"

          Open3.popen3 "pg_dump -h #{host} -p #{port} -U #{username} #{database} > #{dump_file}" do |i, o, e, t|
            if t.value.success?
              ZipFile.open(zip_file, ZipFile::CREATE) { |zip| zip.add File.basename(dump_file), dump_file }
              storages.each { |s| s.save zip_file }
            else
              EasyBackup.logger.error "[PostgreSQL] Error: #{e.readlines.join}"
            end
          end

          FileUtils.rm dump_file if File.exist? dump_file
          FileUtils.rm zip_file if File.exist? zip_file
        end
      end
    end
  end
end

