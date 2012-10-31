module EasyBackup
  class Specification

    def initialize(&block)
      @resources = []
      @storages = []
      instance_eval &block if block_given?
    end

    def save(resource_class, &block)
      raise "#{resource_class} not respond to send_to" unless resource_class.instance_methods.include? :send_to
      @resources << resource_class.new
      @resources.last.instance_eval &block if block_given?
    end

    def into(resource_class, &block)
      raise "#{resource_class} not respond to save" unless resource_class.instance_methods.include? :save
      @storages << resource_class.new
      @storages.last.instance_eval &block if block_given?
    end

    def schedule(frequency, *args)
      EasyBackup.scheduler.send(frequency, *args) do
        EasyBackup.configuration.logger.info "[EasyBackup] Starting at #{Time.now}"
        run
      end
    end

    def run
      @resources.each do |resource|
        resource.send_to *@storages
      end
    end

  end
end