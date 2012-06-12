module EasyBackup
  module Adapter
    class FileSystem
      attr_reader :folders, :files

      def initialize
        @folders = []
        @files = []
      end

      def folder(path)
        @folders << path
      end

      def file(file_name)
        @files << file_name
      end

      def send_to(storages)
        (files | folders).each do |resource|
          storages.each { |s| s.save resource } if File.exist? resource
        end
      end

      def save(resource)
        folders.each do |folder|
          FileUtils.mkpath folder unless Dir.exist? folder
          puts resource
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

