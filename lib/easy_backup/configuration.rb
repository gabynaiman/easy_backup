module EasyBackup
  class Configuration
    attr_reader :guards, :storages, :frequencies

    def initialize(&block)
      @guards = []
      @storages = []
      @frequencies = []
      instance_eval &block if block_given?
    end

    def guard(adapter_class, &block)
      guards << adapter_class.new
      guards.last.instance_eval &block if block_given?
    end

    def store_in(adapter_class, &block)
      storages << adapter_class.new
      storages.last.instance_eval &block if block_given?
    end

    def every(adapter_class, &block)
      frequencies << adapter_class.new
      frequencies.last.instance_eval &block if block_given?
    end

  end
end