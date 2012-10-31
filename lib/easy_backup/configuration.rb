module EasyBackup
  class Configuration

    def logger
      @logger ||= Logger.new($stdout)
    end

    def logger=(logger)
      @logger = logger
    end

    def tmp_path
      @tmp_path ||= "#{ENV['tmp'].gsub('\\', '/')}/easy_backup"
    end

    def tmp_path=(path)
      @tmp_path = path
    end

  end
end