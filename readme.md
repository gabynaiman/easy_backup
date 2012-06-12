### DSL Example

``` rb
EasyBackup.config :analyst_lab do

  guard Pg do
    host 'localhost'
    database 'analyst_lab'
    username 'postgres'
    password 'password'
  end

  guard FileSystem do
    folder 'c:/analyst_lab/repository'
    folder 'c:/temp/xxx'
  end

  store_in FileSystem do
    folder "c:/backups/analyst_lab/#{Time.now.to_s}"
  end

  every Day do
    at '03:00:00'
  end

end
```