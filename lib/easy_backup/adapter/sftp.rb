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
        folder ? @folder = folder : @folder
      end

      def save(resource)
        Net::SFTP.start(host, username, :password => password) do |sftp|
          #TODO: Crear las carpetas de forma recursiva
          sftp.mkdir! folder
          sftp.upload! resource, "#{folder}/#{File.basename(resource)}"
        end
      end
    end
  end
end