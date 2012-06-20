require 'rufus-scheduler'

module EasyBackup

  class Base

    def initialize(interval=EasyBackup.interval, &block)
      @configurations = {}
      instance_eval &block
      @scheduler = Rufus::Scheduler.start_new frequency: interval
      schedule
    end

    def [](name)
      @configurations[name]
    end

    def start
      @scheduler.join
    end

    private

    def []=(name, value)
      @configurations[name] = value
    end

    def config(name=:default, &block)
      self[name] = Configuration.new do
        instance_eval &block
      end
    end

    def schedule
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