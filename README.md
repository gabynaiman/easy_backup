## DSL Example

``` rb
EasyBackup.config do

  save PostgreSQL do
    host     'localhost'
    port     5432
    database 'db_production'
    username 'user_prod'
    password 'password'
  end

  save FileSystem do
    folder 'c:/resources'
    file   'c:/data/file.txt'
  end

  into FileSystem do
    folder "c:/backups/#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end

  into SFTP do
    host     'remote'
    username 'user_sftp'
    password 'password'
    folder   "backups/#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end

  every 1.day, from: 'today at 22:30'

end
```