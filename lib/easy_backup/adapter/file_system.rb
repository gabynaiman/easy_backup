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
    end
  end
end

