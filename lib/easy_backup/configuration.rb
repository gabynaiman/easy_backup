module EasyBackup
  class Configuration
    attr_reader :resources, :storages

    def initialize(&block)
      @resources = []
      @storages = []
      instance_eval &block if block_given?
    end

    def save(adapter_class, &block)
      resources << adapter_class.new
      resources.last.instance_eval &block if block_given?
    end

    def into(adapter_class, &block)
      storages << adapter_class.new
      storages.last.instance_eval &block if block_given?
    end

  end
end