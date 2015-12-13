desc 'Bootstrap host'
task :bootstrap do
  on roles(:web) do
    info 'Bootstrapping host...'
    bootstrap_path = '/tmp/bootstrap'
    upload! './bootstrap', '/tmp', recursive: true
    within bootstrap_path do
      info capture(:pwd)
      unless execute 'hash "chef-solo" 2>/dev/null'
        execute 'apt-get update'
        execute 'apt-get upgrade -y'
        execute :wget, 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb'
        execute :dkpg, '-i chefdk_*.deb'
      end
      execute :berks, 'vendor'
      execute "chef-solo -c #{bootstrap_path}/site_install.rb -j #{bootstrap_path}/chef_config.json"
    end
  end
end
