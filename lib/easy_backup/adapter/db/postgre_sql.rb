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

        def dump_file(file_name=nil)
          file_name ? @dump_file = file_name : (@dump_file || "#{database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql")
        end

        def zip_file(file_name=nil)
          file_name ? @zip_file = file_name : @zip_file
        end

        def zip
          zip_file "#{File.basename(dump_file, '.*')}.zip"
        end

        def send_to(storages)
          FileUtils.mkpath File.dirname(path_to(dump_file)) unless Dir.exist? File.dirname(path_to(dump_file))

          EasyBackup.logger.info "[PostgreSQL] Dump postgres://#{username}:*****@#{host}:#{port}/#{database}\n#{' '*15}to #{path_to(dump_file)}"

          Open3.popen3 "pg_dump -h #{host} -p #{port} -U #{username} #{database} > #{path_to(dump_file)}" do |i, o, e, t|
            if t.value.success?
              if zip_file
                EasyBackup.logger.info "#{(' '*14)}zip #{path_to(zip_file)}"
                ZipFile.open(path_to(zip_file), ZipFile::CREATE) { |zip| zip.add dump_file, path_to(dump_file) }
              end
              storages.each { |s| s.save path_to(zip_file ? zip_file : dump_file) }
            else
              EasyBackup.logger.error "[PostgreSQL] Error: #{e.readlines.join}"
            end
          end

          FileUtils.rm path_to(dump_file) if File.exist? path_to(dump_file)
          FileUtils.rm path_to(zip_file) if zip_file && File.exist?(path_to(zip_file))
        end

        private

        def path_to(file_name)
          "#{EasyBackup.tmp_path}/pg_dump/#{file_name}"
        end
      end
    end
  end
end

