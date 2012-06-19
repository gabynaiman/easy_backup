require 'spec_helper'

describe SFTP, '-> Specification' do

  it 'Specify sftp parameters' do
    sftp = SFTP.new
    sftp.host '192.168.0.1'
    sftp.username 'user'
    sftp.password 'password'
    sftp.folder '/backup'

    sftp.host.should eq '192.168.0.1'
    sftp.username.should eq 'user'
    sftp.password.should eq 'password'
    sftp.folder.should eq '/backup'
  end

end