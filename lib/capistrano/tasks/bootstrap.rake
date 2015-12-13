namespace :bootstrap do
  task :default do
    invoke 'bootstrap:install_chef'
    invoke 'bootstrap:update_config'
  end

  desc 'Update Ubuntu and install ChefDK'
  task :install_chef do
    on roles(:web) do
      within '/tmp' do
        begin
          execute 'chef-solo -v'
        rescue
          execute 'apt-get update'
          execute 'apt-get upgrade -y'
          execute :wget, 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb -nv'
          execute :dpkg, '-i chefdk_*.deb'
        end
      end
    end
  end

  desc 'Upload bootstrap library and run chef-solo'
  task :update_config do
    on roles(:web) do
      bootstrap_path = '/tmp/bootstrap'
      upload! './bootstrap', '/tmp', recursive: true
      within bootstrap_path do
        execute :berks, 'vendor'
        execute "chef-solo -c #{bootstrap_path}/site_install.rb -j #{bootstrap_path}/chef_config.json"
      end
    end
  end
end

desc 'Run bootstrap:install_chef and bootstrap:update_config'
task bootstrap: "bootstrap:default"
