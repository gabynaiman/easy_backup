require 'spec_helper'

describe 'Scheduler' do

  it 'Schedule specification' do
    sample_file = "#{DATA_PATH}/sample.json"
    target_folder = file_helper.create_temp_folder

    Specification.new do
      save FileSystem do
        file sample_file
      end

      into FileSystem do
        folder lambda { "#{target_folder}/#{Time.now.to_f}" }
      end

      schedule :every, 0.6
    end

    sleep(1)

    Dir.glob("#{target_folder}/*/").count.should eq 1
  end

end