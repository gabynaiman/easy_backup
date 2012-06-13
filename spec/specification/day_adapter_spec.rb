require 'spec_helper'
require 'easy_backup'

include EasyBackup::Adapter::Frequency

describe Day, '-> Specification' do

  it 'Specify hour' do
    day = Day.new
    day.at 15

    day.hour.should be 15
    day.minute.should be 0
    day.second.should be 0
  end

  it 'Specify hour and minute' do
    day = Day.new
    day.at '12:30'

    day.hour.should be 12
    day.minute.should be 30
    day.second.should be 0
  end

  it 'Specify hour, minute and second' do
    day = Day.new
    day.at '17:25:06'

    day.hour.should be 17
    day.minute.should be 25
    day.second.should be 06
  end

end