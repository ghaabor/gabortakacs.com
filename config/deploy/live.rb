server 'gabortakacs.com',
  user: 'root',
  roles: %w{web},
  ssh_options: {
    user: 'root',
    keys: %w(~/.ssh/id_rsa),
    auth_methods: %w(publickey)
  }
