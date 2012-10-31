require 'spec_helper'

describe Specification do

  context 'Configuration' do

    it 'Validate source resource' do
      expect{Specification.new { save Object }}.should raise_exception
    end

    it 'Validate target resource' do
      expect{Specification.new { into Object }}.should raise_exception
    end

  end

  context 'Running' do

    it 'Save file into folder' do
      sample_file = "#{DATA_PATH}/sample.json"
      target_folder = file_helper.create_temp_folder

      spec = Specification.new do
        save FileSystem do
          file sample_file
        end

        into FileSystem do
          folder target_folder
        end
      end

      spec.run

      File.exists?("#{target_folder}/#{File.basename(sample_file)}").should be_true
    end

  end

end