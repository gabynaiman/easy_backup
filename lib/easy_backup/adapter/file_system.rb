module EasyBackup
  module Adapter
    class FileSystem
      attr_reader :folders

      def initialize
        @folders = []
      end

      def folder(path)
        @folders << path
      end
    end
  end
end

