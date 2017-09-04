class db::backend::mysql {

  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts => true,
  }

  mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }
}
