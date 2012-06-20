require 'rufus-scheduler'

module EasyBackup

  class Base

    def initialize(interval=1.minute, &block)
      @configurations = {}
      instance_eval &block if block_given?
      @scheduler = Rufus::Scheduler.start_new frequency: interval
      run
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
      @scheduler.join
    end

    private

    def run
      @configurations.each_value do |c|
        c.frequencies.each do |f|
          @scheduler.every f.interval, first_at: f.from do
            Runner.run c
          end
        end
      end
    end


  end
end