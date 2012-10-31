module EasyBackup
  module Resources
    class FileSystem
      include Zip

      def initialize(&block)
        @folders = []
        @files = []
        instance_eval &block if block_given?
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
        zip_path(@zip_file.is_a?(Proc) ? @zip_file.call : @zip_file)
      end

      def save(resource)
        folders.each do |folder|
          EasyBackup.configuration.logger.info "[EasyBackup] Saving #{resource} into #{folder}"

          FileUtils.mkpath folder unless Dir.exist? folder
          if Dir.exist? resource
            FileUtils.cp_r resource, "#{folder}/#{File.basename(resource)}"
          else
            FileUtils.cp resource, "#{folder}/#{File.basename(resource)}"
          end
        end
      end

      def send_to(*storages)
        if zip_file
          EasyBackup.configuration.logger.info "[EasyBackup] Zip #{zip_file}"
          FileUtils.mkpath File.dirname(zip_file) unless Dir.exist? File.dirname(zip_file)
          ZipFile.open(zip_file, ZipFile::CREATE) do |zip|
            (files | folders).each do |resource|
              if Dir.exist? resource
                EasyBackup.configuration.logger.debug "[EasyBackup] add #{resource}"
                Dir.glob("#{resource}/**/**", File::FNM_DOTMATCH).reject{|entry| entry =~ /\/[\.]+\z/}.each do |r|
                  EasyBackup.configuration.logger.debug "[EasyBackup] add #{r}" unless Dir.exist? r
                  zip.add "#{File.basename(resource)}/#{r.gsub("#{resource}/", '')}", r
                end
              else
                EasyBackup.configuration.logger.debug "[EasyBackup] add #{resource}"
                zip.add File.basename(resource), resource
              end
            end
          end
          storages.each { |s| s.save zip_file }
          FileUtils.rm zip_file
        else
          (files | folders).each do |resource|
            storages.each { |s| s.save resource } if File.exist? resource
          end
        end
      end

      private

      def zip_path(file_name)
        return nil unless file_name
        "#{EasyBackup.configuration.tmp_path}/zip/#{file_name}"
      end

    end
  end
end