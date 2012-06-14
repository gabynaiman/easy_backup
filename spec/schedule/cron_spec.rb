require 'spec_helper'

include EasyBackup::Schedule

describe Cron do

  it 'Execute block every at specific moment' do
    time = Time.now + 1
    last_run = nil

    cron = Cron.new(Timer.new 0.5) do
      at time do
        last_run = Time.now
      end
    end

    cron.start
    sleep(1.5)
    cron.stop

    last_run.to_s.should eq time.to_s
  end

end