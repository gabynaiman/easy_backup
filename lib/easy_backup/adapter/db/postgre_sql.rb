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
          if file_name
            @dump_file = file_name
          else
            if @dump_file
              @dump_file.is_a?(Proc) ? @dump_file.call : @dump_file
            else
              "#{database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
            end
          end
        end

        def zip_file(file_name=nil)
          if file_name
            @zip_file = file_name
          else
            @zip_file.is_a?(Proc) ? @zip_file.call : @zip_file
          end
        end

        def zip
          zip_file lambda { "#{File.basename(dump_file, '.*')}.zip" }
        end

        def send_to(storages)
          dump_file_name = path_to(dump_file)
          zip_file_name = path_to(zip_file)

          FileUtils.mkpath File.dirname(dump_file_name) unless Dir.exist? File.dirname(dump_file_name)

          EasyBackup.logger.info "[PostgreSQL] Dump postgres://#{username}:*****@#{host}:#{port}/#{database}\n#{' '*15}to #{dump_file_name}"

          Open3.popen3 "pg_dump -h #{host} -p #{port} -U #{username} #{database} > #{dump_file_name}" do |i, o, e, t|
            if t.value.success?
              if zip_file
                EasyBackup.logger.info "#{(' '*14)}zip #{zip_file_name}"
                ZipFile.open(zip_file_name, ZipFile::CREATE) do |zip|
                  zip.add File.basename(dump_file_name), dump_file_name
                end
              end
              storages.each { |s| s.save(zip_file ? zip_file_name : dump_file_name) }
            else
              EasyBackup.logger.error "[PostgreSQL] Error: #{e.readlines.join}"
            end
          end

          FileUtils.rm dump_file_name if File.exist? dump_file_name
          FileUtils.rm zip_file_name if zip_file && File.exist?(zip_file_name)
        end

        private

        def path_to(file_name)
          "#{EasyBackup.tmp_path}/pg_dump/#{file_name}"
        end
      end
    end
  end
end

