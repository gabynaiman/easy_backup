### DSL Example

``` rb
backup :demo_backup do

  save PostgreSQL do
    host     'localhost'
    port     5432
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

  into SFTP do
    host     'remote'
    username 'user_sftp'
    password 'password'
    folder   "backups/#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end

  every Day do
    at '03:00:00'
  end

end
```