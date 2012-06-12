### DSL Example

``` rb
EasyBackup.config :demo_backup do

  save PostgreSQL do
    host 'localhost'
    database 'db_production'
    username 'user_prod'
    password 'password'
  end

  save FileSystem do
    folder 'c:/resources'
    file 'c:/data/file.txt'
  end

  into FileSystem do
    folder "c:/backups/#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end

  every Day do
    at '03:00:00'
  end

end
```