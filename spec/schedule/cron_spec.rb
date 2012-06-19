require 'spec_helper'

describe Cron do

  it 'Execute block at specific moment' do
    time = Time.now + 1
    last_run = nil

    cron = Cron.new(0.5) do
      at time do
        last_run = Time.now
      end
    end

    cron.start
    sleep(1.5)
    cron.stop

    last_run.to_s.should eq time.to_s
  end

  it 'Execute multiple tasks with threads at specific moment' do
    time = Time.now + 1
    order = []

    cron = Cron.new(0.5) do
      at time do
        order << 1
        sleep(1)
        order << 3
      end
      at time do
        order << 2
      end
    end

    cron.start
    sleep(2.5)
    cron.stop

    order.should eq [1, 2, 3]
  end

end