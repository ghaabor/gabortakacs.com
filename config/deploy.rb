# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'gabortakacs_com'
set :repo_url, 'https://github.com/ghaabor/gabortakacs.com.git'
set :repo_tree, 'site'
set :format, :pretty
set :log_level, :debug
set :keep_releases, 10

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
