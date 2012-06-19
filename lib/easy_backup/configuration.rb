module EasyBackup
  class Configuration
    attr_reader :resources, :storages, :frequencies

    def initialize(&block)
      @resources = []
      @storages = []
      @frequencies = []
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

    def every(interval, options={})
      frequencies << Frequency.new(interval, options)
    end

    def schedule(scheduler)
      @frequencies.each do |f|
        scheduler.every f.interval, from: f.from, to: f.to do
          Runner.run self
        end
      end
    end

  end
end