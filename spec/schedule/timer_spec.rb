require 'spec_helper'

include EasyBackup::Schedule

describe Timer do

  it 'Execute block after each interval' do
    times = 0

    timer = Timer.new 0.9 do
      times += 1
    end

    timer.start
    sleep(2)
    timer.stop

    times.should be 2
  end

end
