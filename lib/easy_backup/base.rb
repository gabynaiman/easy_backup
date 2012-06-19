module EasyBackup

  class Base

    def initialize(interval=1.minute, &block)
      @scheduler = Scheduler.new interval
      @configurations = {}
      instance_eval &block if block_given?
    end

    def [](name)
      @configurations[name]
    end

    def []=(name, value)
      @configurations[name] = value
    end

    def config(name, &block)
      self[name] = Configuration.new do
        instance_eval &block
      end
    end

    def load(config_file)
      eval File.open(config_file, 'r') { |f| f.readlines.join("\n") }
    end

    def start
      @configurations.each_value do |c|
        c.schedule @scheduler
      end
      @scheduler.start
    end

    def stop
      @scheduler.stop
    end

  end
end