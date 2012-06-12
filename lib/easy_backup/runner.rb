module EasyBackup
  class Runner
    def self.run(configuration)
      configuration.resources.each do |resource|
        resource.send_to configuration.storages
      end
    end
  end
end