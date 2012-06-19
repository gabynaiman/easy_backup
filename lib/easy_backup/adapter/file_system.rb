module EasyBackup
  module Adapter
    class FileSystem

      def initialize
        @folders = []
        @files = []
      end

      def folder(path)
        @folders << path
      end

      def folders
        @folders.map{|f| f.is_a?(Proc) ? f.call : f}
      end

      def file(file_name)
        @files << file_name
      end

      def files
        @files.map{|f| f.is_a?(Proc) ? f.call : f}
      end

      def send_to(storages)
        (files | folders).each do |resource|
          EasyBackup.logger.debug "[FileSystem] Sending resource #{resource}"
          storages.each { |s| s.save resource } if File.exist? resource
        end
      end

      def save(resource)
        folders.each do |folder|
          EasyBackup.logger.debug "[FileSystem] Saving into #{folder}"
          FileUtils.mkpath folder unless Dir.exist? folder
          if Dir.exist? resource
            FileUtils.cp_r resource, "#{folder}/#{File.basename(resource)}"
          else
            FileUtils.cp resource, "#{folder}/#{File.basename(resource)}"
          end
        end
      end

    end
  end
end

