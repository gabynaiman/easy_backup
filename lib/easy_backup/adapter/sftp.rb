require 'net/sftp'

module EasyBackup
  module Adapter
    class SFTP
      def host(host=nil)
        host ? @host = host : @host
      end

      def username(username=nil)
        username ? @username = username : @username
      end

      def password(password=nil)
        password ? @password = password : @password
      end

      def folder(folder=nil)
        if folder
          @folder = folder
        else
          @folder.is_a?(Proc) ? @folder.call : @folder
        end
      end

      def save(resource)
        Net::SFTP.start(host, username, :password => password) do |sftp|
          sftp_folder = folder
          EasyBackup.logger.info "[SFTP] Saving #{resource}\n#{' '*9}into #{host} | #{username} | #{sftp_folder}"

          sftp.mkpath! sftp_folder, :progress => SFTPHandler.new
          sftp.upload! resource, "#{sftp_folder}/#{File.basename(resource)}", :progress => SFTPHandler.new
        end
      end
    end

    class SFTPHandler
      def on_open(uploader, file)
        EasyBackup.logger.info "#{' '*9}starting upload: #{file.local} -> #{file.remote} (#{file.size} bytes)"
      end

      def on_put(uploader, file, offset, data)
        EasyBackup.logger.info "#{' '*9}#{data.length} bytes to #{file.remote} starting at #{offset}"
      end

      def on_close(uploader, file)
        EasyBackup.logger.info "#{' '*9}finished with #{file.remote}"
      end

      def on_mkdir(uploader, path)
        EasyBackup.logger.info "#{' '*9}creating directory #{path}"
      end

      def on_finish(uploader)
        EasyBackup.logger.info "#{' '*9}all done!"
      end
    end
  end
end