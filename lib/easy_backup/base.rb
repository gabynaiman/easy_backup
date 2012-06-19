module EasyBackup

  class Base

    def initialize(&block)
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

  end
end