config :test_backup do

  save PostgreSQL do
    host 'localhost'
    database 'test_db'
    username 'user'
    password 'password'
  end

  save FileSystem do
    folder 'c:/data'
  end

  into FileSystem do
    folder 'c:/backup'
  end

  every 1.day, from: 'today at 22:30'

end
