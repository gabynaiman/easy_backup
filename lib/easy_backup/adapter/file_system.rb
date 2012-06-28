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
        @folders.map { |f| f.is_a?(Proc) ? f.call : f }
      end

      def file(file_name)
        @files << file_name
      end

      def files
        @files.map { |f| f.is_a?(Proc) ? f.call : f }
      end

      def zip(file_name)
        @zip_file = file_name
      end

      def zip_file
        @zip_file.is_a?(Proc) ? @zip_file.call : @zip_file
      end

      def send_to(storages)
        if zip_file
          zip_file_name = zip_path(zip_file)

          EasyBackup.logger.info "[FileSystem] Zip #{zip_file_name}"
          FileUtils.mkpath File.dirname(zip_file_name)
          ZipFile.open(zip_file_name, ZipFile::CREATE) do |zip|
            (files | folders).each do |resource|
              if Dir.exist? resource
                EasyBackup.logger.debug "#{' '*13}add #{resource}"
                Dir.glob("#{resource}/**/**", File::FNM_DOTMATCH).reject{|entry| entry =~ /\/[\.]+\z/}.each do |r|
                  EasyBackup.logger.debug "#{' '*13}add #{r}" unless Dir.exist? r
                  zip.add "#{File.basename(resource)}/#{r.gsub("#{resource}/", '')}", r
                end
              else
                EasyBackup.logger.debug "#{' '*13}add #{resource}"
                zip.add File.basename(resource), resource
              end
            end
          end
          storages.each { |s| s.save zip_file_name }
          FileUtils.rm zip_file_name
        else
          (files | folders).each do |resource|
            storages.each { |s| s.save resource } if File.exist? resource
          end
        end
      end

      def save(resource)
        folders.each do |folder|
          EasyBackup.logger.info "[FileSystem] Saving #{resource}\n#{' '*15}into #{folder}"

          FileUtils.mkpath folder unless Dir.exist? folder
          if Dir.exist? resource
            FileUtils.cp_r resource, "#{folder}/#{File.basename(resource)}"
          else
            FileUtils.cp resource, "#{folder}/#{File.basename(resource)}"
          end
        end
      end

      private

      def zip_path(file_name)
        "#{EasyBackup.tmp_path}/zip/#{file_name}"
      end

    end
  end
end

