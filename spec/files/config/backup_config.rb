backup :test_backup do

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

  every Day do
    at '22:30'
  end

end
