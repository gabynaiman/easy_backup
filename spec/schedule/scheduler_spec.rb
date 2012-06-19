require 'spec_helper'

describe Scheduler do

  it 'Execute task every 1 second' do
    count = 0

    scheduler = Scheduler.new(0.2) do
      every 1.second do
        count += 1
      end
    end

    scheduler.start
    sleep(3.5)
    scheduler.stop

    count.should be 3
  end

  it 'Execute task every 1 second starting at specific time' do
    count = 0

    scheduler = Scheduler.new(0.2) do
      every 1.second, from: Time.now + 1 do
        count += 1
      end
    end

    scheduler.start
    sleep(3.5)
    scheduler.stop

    count.should be 2
  end

  it 'Execute task every 1 second ending at specific time' do
    count = 0

    scheduler = Scheduler.new(0.2) do
      every 1.second, to: Time.now + 2.5 do
        count += 1
      end
    end

    scheduler.start
    sleep(3.5)
    scheduler.stop

    count.should be 2
  end

end
