module EasyBackup
  module Resources
    class Postgres
      include Zip

      def initialize(&block)
        instance_eval &block if block_given?
      end

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
          @dump = file_name
        else
          @dump_file || update_dump_file
        end
      end

      def zip_file
        @zip_file || update_zip_file
      end

      def zip
        @zip = lambda { "#{File.basename(dump_file, '.*')}.zip" }
      end

      def send_to(*storages)
        update_dump_file

        FileUtils.mkpath File.dirname(dump_file) unless Dir.exist? File.dirname(dump_file)

        EasyBackup.configuration.logger.info "[EasyBackup] Dump postgres://#{username}:*****@#{host}:#{port}/#{database} to #{dump_file}"

        Open3.popen3 "pg_dump -h #{host} -p #{port} -U #{username} #{database} > #{dump_file}" do |i, o, e, t|
          if t.value.success?
            if update_zip_file
              EasyBackup.configuration.logger.info "[EasyBackup] Zip #{dump_file} to #{zip_file}"
              ZipFile.open(zip_file, ZipFile::CREATE) do |zip|
                zip.add File.basename(dump_file), dump_file
              end
            end
            storages.each { |s| s.save(zip_file ? zip_file : dump_file) }
          else
            EasyBackup.configuration.logger.error "[EasyBackup] Error: #{e.readlines.join}"
          end
        end

        FileUtils.rm dump_file if File.exist? dump_file
        FileUtils.rm zip_file if zip_file && File.exist?(zip_file)
      end

      private

      def update_dump_file
        if @dump
          @dump_file = path_to(@dump.is_a?(Proc) ? @dump.call : @dump)
        else
          @dump_file = path_to "#{database}_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
        end
      end

      def update_zip_file
        return nil unless @zip
        @zip_file = path_to(@zip.call)
      end

      def path_to(file_name)
        return nil unless file_name
        "#{EasyBackup.configuration.tmp_path}/pg_dump/#{file_name}"
      end

    end
  end
end